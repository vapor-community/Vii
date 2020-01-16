import PostgresKit

class ViiPostgresConnection: ViiConnection {

    var connection: PostgresConnection

    init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try PostgresConnection.create(on: eventLoop, credentials: credentials).wait()
    }
    
    func getTables(schema: String) -> EventLoopFuture<[ViiTable]> {
        return self.connection.withConnection{ db in
            return db.sql()
                     .raw("SELECT table_name::text FROM information_schema.tables WHERE table_schema='public'")
                     .all(decoding: ViiTable.self)
            
        }
    }
    
    func close() {
        try! self.connection.close().wait()
    }
}
