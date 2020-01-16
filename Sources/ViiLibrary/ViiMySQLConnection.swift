import MySQLKit

public class ViiMySQLConnection: ViiConnection {
    
    public var connection: MySQLConnection

    public init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try ViiMySQL(eventLoop: eventLoop, credentials: credentials).connection
    }
    
    public func getTables() -> EventLoopFuture<[ViiTable]> {
        return self.connection.withConnection { db in
            return db.sql()
                     .raw("SELECT table_name FROM information_schema.tables WHERE table_schema = 'vapor'")
                     .all(decoding: ViiTable.self)
        }
    }
    
    public func close() {
         try! self.connection.close().wait() 
    }
}


