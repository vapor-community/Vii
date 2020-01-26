import PostgresKit

class ViiPostgresConnection: ViiConnection {

    var connection: PostgresConnection
    var schema: String

    init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try PostgresConnection.create(on: eventLoop, credentials: credentials).wait()
        self.schema = credentials.database
    }
    
    func getTables() -> EventLoopFuture<[ViiTable]> {
        return self.connection.withConnection{ db in
            return db.sql()
                     .raw("""
                        SELECT table_name::text as "tableName" FROM information_schema.tables WHERE table_schema='public'
                     """)
                     .all(decoding: ViiTable.self)
            
        }
    }
    
    func close() {
        try! self.connection.close().wait()
    }
}

extension ViiPostgresConnection: ViiGenerate {
    func getColumns(table: String) -> EventLoopFuture<[ViiColumn]> {
        return self.connection.withConnection { db in
            return db.sql()
                     .raw("""
                        SELECT column_name::TEXT as "columnName", udt_name::TEXT as "dataType",
                               is_nullable::BOOLEAN as "isNullable"
                        FROM information_schema.columns
                        WHERE table_schema = 'public'
                        AND table_name = \(bind: table)
                    """)
                    .all(decoding: ViiColumn.self)
        }
    }
}
