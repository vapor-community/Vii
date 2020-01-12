import ConsoleKit
import ViiLibrary
import NIO

final class ViiCommand: Command {
    
    private var eventLoopGroup: EventLoopGroup!
    private var eventLoop: EventLoop { return self.eventLoopGroup.next() }
    
    init(eventLoopGroup: EventLoopGroup) {
        self.eventLoopGroup = eventLoopGroup
    }
    
    func run(using context: CommandContext, signature: ViiCommand.Signature) throws {
        let dbArgument = signature.db
        let dbType = ViiDatabaseType(rawValue: dbArgument)
        guard let db = dbType else {
            throw CommandError.invalidArgumentType("database", type: ViiDatabaseType.Type.self)
        }
        sayHello()
        
        // @todo, tidy user supplied credentials
        let host = context.console.ask("database host")
        let port = context.console.ask("database port")
        let username = context.console.ask("database username")
        let password = context.console.ask("database password")
        let name = context.console.ask("database name")
        
        let credentials = Credential(port: port, host: host, username: username, password: password, database: database)
        // @todo, convert to factory
        let dbConnection = AnyViiConnection(ViiPostgresConnection(eventLoop: self.eventLoop, credentials: credentials))
        let connection = try dbConnection.connection.wait()
        let tables = try connection.getTables(schema: nil, skip: nil).wait()
        
        print(tables)
        // @todo move to main.swift/protocol
        defer { try! connection.close().wait() }
    }
    
    struct Signature: CommandSignature {
        @Argument(name: "db", help: "Specify what RDBMs you're using")
        var db: String
        
        @Option(name: "skipTable", help: "Skip tables from code generation by providing comma separated argument --skipTable=fluent,user...")
        var skipName: String?
        
        init() {}
    }
    
    var help: String {
        "A magical tool that builds Vapor models from RDBMs"
    }
    
    /// A little welcome piece for the console
    func sayHello() {
        for line in welcome {
            console.output(line.consoleText(color: .brightMagenta))
        }
    }

    private let welcome: [String] = [
       " __      ___ _    _____          _         _____                           _                ",
       " \\ \\    / (_|_)  / ____|        | |       / ____|                         | |               ",
       "  \\ \\  / / _ _  | |     ___   __| | ___  | |  __  ___ _ __   ___ _ __ __ _| |_ ___  _ __    ",
       "   \\ \\/ / | | | | |    / _ \\ / _` |/ _ \\ | | |_ |/ _ \\ '_ \\ / _ \\ '__/ _` | __/ _ \\| '__|  ",
       "    \\  /  | | | | |___| (_) | (_| |  __/ | |__| |  __/ | | |  __/ | | (_| | || (_) | |     ",
       "     \\/   |_|_|  \\_____\\___/ \\__,_|\\___|  \\_____|\\___|_| |_|\\___|_|  \\__,_|\\__\\___/|_|     "
    ]

}
