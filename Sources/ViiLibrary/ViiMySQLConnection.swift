import MySQLKit

class ViiMySQLConnection: ViiConnection {

    var connection: MySQLConnection

    init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try MySQLConnection.create(on: eventLoop, credentials: credentials).wait()
    }

    func getTables() -> EventLoopFuture<[Table]> {
        return self.connection.withConnection { db in
            return db.sql()
                     .select()
                     .column(SQLAlias(SQLRaw("table_name"), as: SQLRaw("\"tableName\"")))
                     .from(SQLRaw("information_schema.tables"))
                     .where(SQLRaw("table_schema"), .equal, SQLRaw("schema()"))
                     .all(decoding: Table.self)
        }
    }

    func close() {
         try? self.connection.close().wait()
    }

    func getColumns(table: Table) -> EventLoopFuture<[Column]> {
        return self.connection.withConnection { db in
            return db.sql()
                     .select()
                     .column(SQLAlias(SQLRaw("COLUMN_NAME"), as: SQLRaw("\"columnName\"")))
                     .column(SQLAlias(SQLRaw("DATA_TYPE"), as: SQLRaw("\"dataType\"")))
                     .column(SQLAlias(SQLRaw("CASE WHEN IS_NULLABLE = 'NO' THEN FALSE ELSE TRUE END"),
                                     as: SQLRaw("\"isNullable\"")))
                     .from(SQLRaw("information_schema.columns"))
                     .where(SQLRaw("table_schema"), .equal, SQLRaw("schema()"))
                     .where(SQLRaw("TABLE_NAME"), .equal, SQLRaw("'\(table.tableName)'"))
                     .orderBy(SQLRaw("table_name, ordinal_position"))
                     .all(decoding: Column.self)
        }
    }

    func getPrimaryKey(table: Table) -> EventLoopFuture<PrimaryKey?> {
        return self.connection.withConnection { db in
            return db.sql()
                     .select()
                     .column(SQLAlias(SQLRaw("kcu.column_name"), as: SQLRaw("\"columnName\"")))
                     .column(SQLAlias(SQLRaw("c.DATA_TYPE"), as: SQLRaw("\"dataType\"")))
                     .column(SQLAlias(SQLRaw("CASE WHEN c.IS_NULLABLE = 'NO' THEN FALSE ELSE TRUE END"),
                                      as: SQLRaw("\"isNullable\"")))
                     .column(SQLAlias(SQLRaw("c.DATA_TYPE"), as: SQLRaw("\"constrainedTable\"")))
                     .from(SQLAlias(SQLRaw("information_schema.KEY_COLUMN_USAGE"), as: SQLIdentifier("kcu")))
                     .join(SQLAlias(SQLRaw("information_schema.columns"), as: SQLIdentifier("c")),
                          method: SQLJoinMethod.inner,
                          on: SQLRaw("c.table_name = kcu.table_name"))
                     .where(SQLRaw("kcu.table_schema"), .equal, SQLRaw("schema()"))
                     .where(SQLRaw("constraint_name"), .equal, SQLRaw("'PRIMARY'"))
                     .where(SQLRaw("kcu.table_name"), .equal, SQLRaw("'\(table.tableName)'"))
                     .where(SQLRaw("kcu.column_name"), .equal, SQLRaw("c.column_name"))
                     .first(decoding: PrimaryKey.self)
        }
    }

    func getForeignKeys(table: Table) -> EventLoopFuture<[ForeignKey]> {
        return self.connection.withConnection { db in
            return db.sql()
                     .select()
                     .column(SQLAlias(SQLRaw("c.COLUMN_NAME"), as: SQLRaw("\"columnName\"")))
                     .column(SQLAlias(SQLRaw("c.DATA_TYPE"), as: SQLRaw("\"dataType\"")))
                     .column(SQLAlias(SQLRaw("CASE WHEN c.IS_NULLABLE = 'NO' THEN FALSE ELSE TRUE END"),
                                      as: SQLRaw("\"isNullable\"")))
                     .column(SQLAlias(SQLRaw("kcu.REFERENCED_TABLE_NAME"), as: SQLRaw("\"constrainedTable\"")))
                     .from(SQLAlias(SQLRaw("information_schema.TABLE_CONSTRAINTS"), as: SQLIdentifier("tc")))
                     .join(SQLAlias(SQLRaw("information_schema.KEY_COLUMN_USAGE"), as: SQLIdentifier("kcu")),
                           method: SQLJoinMethod.inner,
                           on: SQLRaw("tc.TABLE_NAME = kcu.TABLE_NAME"))
                     .join(SQLAlias(SQLRaw("information_schema.COLUMNS"), as: SQLIdentifier("c")),
                           method: SQLJoinMethod.inner,
                           on: SQLRaw("tc.TABLE_NAME = c.TABLE_NAME"))
                     .where(SQLRaw("tc.CONSTRAINT_TYPE"), .equal, SQLRaw("'FOREIGN KEY'"))
                     .where(SQLRaw("c.EXTRA"), .notEqual, SQLRaw("'auto_increment'"))
                     .where(SQLRaw("tc.TABLE_SCHEMA"), .equal, SQLRaw("schema()"))
                     .where(SQLRaw("tc.TABLE_NAME"), .equal, SQLRaw("'\(table.tableName)'"))
                     .where(SQLRaw("kcu.REFERENCED_TABLE_NAME"), .isNot, SQLRaw("NULL"))
                     .all(decoding: ForeignKey.self)
        }
    }
}
