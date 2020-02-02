import PostgresKit
import Foundation

class ViiPostgresConnection: ViiConnection {

    var connection: PostgresConnection
    var schema: String

    init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try PostgresConnection.create(on: eventLoop, credentials: credentials).wait()
        self.schema = credentials.database
    }
    
    func getTables() -> EventLoopFuture<[Table]> {
        return self.connection.withConnection{ db in
            return db.sql()
                     .raw("""
                        SELECT table_name::text as "tableName" FROM information_schema.tables WHERE table_schema='public'
                     """)
                     .all(decoding: Table.self)
            
        }
    }
    
    func close() {
        try! self.connection.close().wait()
    }
    
    func getColumns(table: Table) -> EventLoopFuture<[Column]> {
        return self.connection.withConnection { db in
            return db.sql()
                     .raw("""
                        SELECT column_name::TEXT as "columnName", udt_name::TEXT as "dataType",
                               is_nullable::BOOLEAN as "isNullable"
                        FROM information_schema.columns
                        WHERE table_schema = 'public'
                        AND table_name = \(bind: table.tableName)
                    """)
                    .all(decoding: Column.self)
        }
    }
    
    private func getBaseKeyQuery() -> String {
        return """
            SELECT kcu.column_name as "columnName",
                   c.udt_name as "dataType",
                   '%@' as constraint,
                   c.is_nullable::BOOLEAN as "isNullable"
            FROM information_schema.table_constraints tc
            JOIN information_schema.constraint_column_usage AS ccu USING (constraint_schema, constraint_name)
            JOIN information_schema.columns AS c ON c.table_schema = tc.constraint_schema
            AND tc.table_name = c.table_name AND ccu.column_name = c.column_name
            JOIN information_schema.key_column_usage AS kcu
            ON tc.constraint_name = kcu.constraint_name
            WHERE constraint_type = '%@' and tc.table_name = '%@';
        """
    }
    
    func getPrimaryKey(table: Table) -> EventLoopFuture<DatabaseKey?> {
        let base = String(format: self.getBaseKeyQuery(), "primary", "PRIMARY KEY", table.tableName)
        let sql = SQLQueryString(stringLiteral: base)
        return self.connection.withConnection { db in
            return db.sql()
                     .raw(sql)
                     .first(decoding: DatabaseKey.self)
        }
    }
    
    func getForeignKeys(table: Table) -> EventLoopFuture<[DatabaseKey]> {
        let base = String(format: self.getBaseKeyQuery(), "foreign", "FOREIGN KEY", table.tableName)
        let sql = SQLQueryString(stringLiteral: base)
        return self.connection.withConnection { db in
            return db.sql()
                     .raw(sql)
                     .all(decoding: DatabaseKey.self)
        }
    }
}
