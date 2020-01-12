import PostgresKit

public class ViiPostgresConnection: ViiConnection {
    
    public typealias ViiConnectionType = EventLoopFuture<PostgresConnection>
    
    public var connection: EventLoopFuture<PostgresConnection>
    
    public init(eventLoop: EventLoop, credentials: Credential){
        self.connection = PostgresConnection.create(on: eventLoop, credentials: credentials)
    }
}

extension PostgresConnection: ViiGetTables {    
    public func getTables(schema: String?, skip: [String]?) -> EventLoopFuture<[ViiTable]> {
        return self.withConnection{ db in
            let schema = schema ?? "public"
            return db.sql()
                     .raw("SELECT table_name::text FROM information_schema.tables WHERE table_schema='\(schema)'")
                     .all(decoding: ViiTable.self)
        }
    }
}
