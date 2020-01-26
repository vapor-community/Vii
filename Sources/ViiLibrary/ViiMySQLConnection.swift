import MySQLKit

class ViiMySQLConnection: ViiConnection {

    var connection: MySQLConnection
    var schema: String

    init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try MySQLConnection.create(on: eventLoop, credentials: credentials).wait()
        self.schema = credentials.database
    }
    
    func getTables() -> EventLoopFuture<[ViiTable]> {
        return self.connection.withConnection { db in
            return db.sql()
                .raw("SELECT table_name as tableName FROM information_schema.tables WHERE table_schema = \(bind: self.schema)")
                .all(decoding: ViiTable.self)
        }
    }
    
    func close() {
         try! self.connection.close().wait() 
    }
}

extension ViiMySQLConnection: ViiGenerate {
    func getColumns(table: String) -> EventLoopFuture<[ViiColumn]> {
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
                        AND TABLE_NAME = \(bind: table)
                        ORDER BY table_name,ordinal_position
                    """)
                .all(decoding: ViiColumn.self)
        }
    }
}


