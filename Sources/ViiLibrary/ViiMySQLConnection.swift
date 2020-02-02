import MySQLKit

class ViiMySQLConnection: ViiConnection {

    var connection: MySQLConnection
    var schema: String

    init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try MySQLConnection.create(on: eventLoop, credentials: credentials).wait()
        self.schema = credentials.database
    }

    func getTables() -> EventLoopFuture<[Table]> {
        return self.connection.withConnection { db in
            return db.sql()
                .raw("SELECT table_name as tableName FROM information_schema.tables WHERE table_schema = \(bind: self.schema)")
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
                        SELECT COLUMN_NAME as columnName,
                               DATA_TYPE as dataType,
                               CASE
                                  WHEN IS_NULLABLE = 'NO' THEN FALSE
                                  ELSE TRUE
                               END AS isNullable
                        FROM information_schema.columns
                        WHERE table_schema = \(bind: self.schema)
                        AND TABLE_NAME = \(bind: table.tableName)
                        ORDER BY table_name,ordinal_position
                    """)
                .all(decoding: Column.self)
        }
    }

    func getPrimaryKey(table: Table) -> EventLoopFuture<DatabaseKey?> {
        return self.connection.withConnection { db in
        return db.sql()
                 .raw("""
                 """)
                .first(decoding: DatabaseKey.self)
        }
    }
    
    func getForeignKeys(table: Table) -> EventLoopFuture<[DatabaseKey]> {
        return self.connection.withConnection { db in
        return db.sql()
                 .raw("""
                 """)
                .all(decoding: DatabaseKey.self)
        }
    }
}
