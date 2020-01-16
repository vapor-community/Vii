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
        // get credentials
        let credentials = try getCredentials(console: context.console)
        let connection = try ConnectionFactory.getViiConnection(selectedDb: db, eventLoop: self.eventLoop, credentials: credentials)
        defer { connection.close() }
        let tables = try connection.getTables(schema: credentials.database).wait()
        print(tables)
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
    
    /// creates a `Credential` struct for connection to DB
    /// - Parameter console: `Console`
    func getCredentials(console: Console) throws -> Credential {
        console.info("We're going to need to use your DB info, please answer the following:", newLine: true)
        let host = console.ask("Your database host eg (127.0.0.1)".consoleText(color: .brightYellow))
        let portAsString = console.ask("What port is your database running on?".consoleText(color: .brightYellow))
        let username = console.ask("The username for this database".consoleText(color: .brightYellow))
        let password = console.ask("The password for this database".consoleText(color: .brightYellow), isSecure: true)
        let database = console.ask("And finally, your database name".consoleText(color: .brightYellow))
        guard let port = Int(portAsString) else {
            console.error("Unable to convert the given database port number of \(portAsString) to integer")
            exit(1)
        }
        return Credential(port: port, host: host, username: username, password: password, database: database)
    }

    private let welcome: [String] = [
       " __      ___ _    _____          _         _____                           _                ",
       " \\ \\    / (_|_)  / ____|        | |       / ____|                         | |               ",
       "  \\ \\  / / _ _  | |     ___   __| | ___  | |  __  ___ _ __   ___ _ __ __ _| |_ ___  _ __    ",
       "   \\ \\/ / | | | | |    / _ \\ / _` |/ _ \\ | | |_ |/ _ \\ '_ \\ / _ \\ '__/ _` | __/ _ \\| '__|  ",
       "    \\  /  | | | | |___| (_) | (_| |  __/ | |__| |  __/ | | |  __/ | | (_| | || (_) | |     ",
       "     \\/   |_|_|  \\_____\\___/ \\__,_|\\___|  \\_____|\\___|_| |_|\\___|_|  \\__,_|\\__\\___/|_|     ",
       "                                                                                                    "
    ]

}
