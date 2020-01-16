import MySQLKit

class ViiMySQLConnection: ViiConnection {
    
    var connection: MySQLConnection

    init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try MySQLConnection.create(on: eventLoop, credentials: credentials).wait()
    }
    
    func getTables(schema: String) -> EventLoopFuture<[ViiTable]> {
        return self.connection.withConnection { db in
            return db.sql()
                .raw("SELECT table_name FROM information_schema.tables WHERE table_schema = \(bind: schema)")
                .all(decoding: ViiTable.self)
        }
    }
    
    func close() {
         try! self.connection.close().wait() 
    }
}


