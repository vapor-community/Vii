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
    
    func getPrimaryKey(table: Table) -> EventLoopFuture<Column?> {
        let sql = """
                SELECT  kcu.column_name as "columnName",
                        c.udt_name as "dataType",
                        c.is_nullable::BOOLEAN as "isNullable"
                FROM information_schema.table_constraints tc
                JOIN information_schema.constraint_column_usage AS ccu USING (constraint_schema, constraint_name)
                JOIN information_schema.columns AS c ON c.table_schema = tc.constraint_schema
                AND tc.table_name = c.table_name AND ccu.column_name = c.column_name
                JOIN information_schema.key_column_usage AS kcu
                ON tc.constraint_name = kcu.constraint_name
                WHERE constraint_type = 'PRIMARY KEY' and tc.table_name = '\(table.tableName)';
                """
        return self.connection.withConnection { db in
            return db.sql()
                     .raw(SQLQueryString(stringLiteral: sql))
                     .first(decoding: Column.self)
        }
    }
    
    func getForeignKeys(table: Table) -> EventLoopFuture<[Column]> {
        // duplicated as String(format:...) not available on Linux
        let sql = """
        SELECT  kcu.column_name as "columnName",
                c.udt_name as "dataType",
                c.is_nullable::BOOLEAN as "isNullable"
        FROM information_schema.table_constraints tc
        JOIN information_schema.constraint_column_usage AS ccu USING (constraint_schema, constraint_name)
        JOIN information_schema.columns AS c ON c.table_schema = tc.constraint_schema
        AND tc.table_name = c.table_name AND ccu.column_name = c.column_name
        JOIN information_schema.key_column_usage AS kcu
        ON tc.constraint_name = kcu.constraint_name
        WHERE constraint_type = 'FOREIGN KEY' and tc.table_name = '\(table.tableName)';
        """
        return self.connection.withConnection { db in
            return db.sql()
                     .raw(SQLQueryString(stringLiteral: sql))
                     .all(decoding: Column.self)
        }
    }
}
