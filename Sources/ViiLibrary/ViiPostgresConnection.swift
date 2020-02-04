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
                        SELECT
                            column_name::TEXT AS "columnName",
                            udt_name::TEXT AS "dataType",
                            is_nullable::BOOLEAN AS "isNullable"
                        FROM
                            information_schema.columns
                        WHERE
                            table_schema = 'public'
                            AND table_name = \(bind: table.tableName)
                    """)
                    .all(decoding: Column.self)
        }
    }
    
    func getPrimaryKey(table: Table) -> EventLoopFuture<Column?> {
        return self.connection.withConnection { db in
            return db.sql()
                     .raw("""
                    SELECT
                         kcu.column_name AS "columnName",
                         c.udt_name AS "dataType",
                         c.is_nullable::BOOLEAN AS "isNullable"
                     FROM
                         information_schema.table_constraints tc
                         JOIN information_schema.constraint_column_usage AS ccu USING (constraint_schema, constraint_name)
                         JOIN information_schema.columns AS c ON c.table_schema = tc.constraint_schema
                             AND tc.table_name = c.table_name
                             AND ccu.column_name = c.column_name
                         JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
                     WHERE
                         constraint_type = 'PRIMARY KEY'
                    AND tc.table_name = \(bind: table.tableName)
                    """)
                     .first(decoding: Column.self)
        }
    }
    
    func getForeignKeys(table: Table) -> EventLoopFuture<[Column]> {
        // duplicated as String(format:...) not available on Linux
        return self.connection.withConnection { db in
            return db.sql()
                     .raw("""
                     SELECT
                         kcu.column_name AS "columnName",
                         c.udt_name AS "dataType",
                         c.is_nullable::BOOLEAN AS "isNullable"
                     FROM
                         information_schema.table_constraints tc
                         JOIN information_schema.constraint_column_usage AS ccu USING (constraint_schema, constraint_name)
                         JOIN information_schema.columns AS c ON c.table_schema = tc.constraint_schema
                             AND tc.table_name = c.table_name
                             AND ccu.column_name = c.column_name
                         JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
                     WHERE
                         constraint_type = 'FOREIGN KEY'
                     AND tc.table_name = \(bind: table.tableName)
                     """)
                     .all(decoding: Column.self)
        }
    }
}
