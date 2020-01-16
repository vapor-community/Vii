import PostgresKit

public class ViiPostgresConnection: ViiConnection {

    public var connection: PostgresConnection

    public init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try ViiPostgres(eventLoop: eventLoop, credentials: credentials).connection
    }
    
    public func getTables() -> EventLoopFuture<[ViiTable]> {
        return self.connection.withConnection{ db in
            return db.sql()
                     .raw("SELECT table_name::text FROM information_schema.tables WHERE table_schema='public'")
                     .all(decoding: ViiTable.self)
            
        }
    }
    
    public func close() {
        try! self.connection.close().wait()
    }
}
