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
        return self.connection.withConnection { db in
            return db.sql()
                     .select()
                     .column(SQLAlias(SQLRaw("table_name::text"), as: SQLRaw("\"tableName\"")))
                     .from(SQLRaw("information_schema.tables"))
                     .where(SQLRaw("table_schema"), .equal, SQLRaw("'public'"))
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
                     .column(SQLAlias(SQLRaw("column_name::TEXT"), as: SQLRaw("\"columnName\"")))
                     .column(SQLAlias(SQLRaw("udt_name::TEXT"), as: SQLRaw("\"dataType\"")))
                     .column(SQLAlias(SQLRaw("is_nullable::BOOLEAN"), as: SQLRaw("\"isNullable\"")))
                     .from(SQLRaw("information_schema.columns"))
                     .where(SQLRaw("table_schema"), .equal, SQLRaw("'public'"))
                     .where(SQLRaw("table_name"), .equal, SQLRaw("'\(table.tableName)'"))
                     .all(decoding: Column.self)
        }
    }

    func getPrimaryKey(table: Table) -> EventLoopFuture<PrimaryKey?> {
        return self.connection.withConnection { db in
            return db.sql()
                     .select()
                     .column(SQLAlias(SQLRaw("kcu.column_name"), as: SQLRaw("\"columnName\"")))
                     .column(SQLAlias(SQLRaw("c.udt_name"), as: SQLRaw("\"dataType\"")))
                     .column(SQLAlias(SQLRaw("c.is_nullable::BOOLEAN"), as: SQLRaw("\"isNullable\"")))
                     .from(SQLAlias(SQLRaw("information_schema.table_constraints"), as: SQLIdentifier("tc")))
                     .join(SQLAlias(SQLRaw("information_schema.constraint_column_usage"),
                                    as: SQLIdentifier("ccu")),
                                    method: SQLJoinMethod.inner,
                                    on: SQLRaw("tc.constraint_schema = ccu.constraint_schema"))
                     .join(SQLAlias(SQLRaw("information_schema.columns"), as: SQLRaw("c")),
                                    method: SQLJoinMethod.inner,
                                    on: SQLRaw("c.table_schema = tc.constraint_schema"))
                     .join(SQLAlias(SQLRaw("information_schema.key_column_usage"), as: SQLRaw("kcu")),
                                    method: SQLJoinMethod.inner,
                                    on: SQLRaw("tc.constraint_name = kcu.constraint_name"))
                     .where(SQLRaw("tc.constraint_name"), .equal, SQLRaw("ccu.constraint_name"))
                     .where(SQLRaw("tc.table_name"), .equal, SQLRaw("c.table_name"))
                     .where(SQLRaw("ccu.column_name"), .equal, SQLRaw("c.column_name"))
                     .where(SQLRaw("constraint_type"), .equal, SQLRaw("'PRIMARY KEY'"))
                     .where(SQLRaw("tc.table_name"), .equal, SQLRaw("'\(table.tableName)'"))
                     .first(decoding: PrimaryKey.self)
        }
    }

    func getForeignKeys(table: Table) -> EventLoopFuture<[ForeignKey]> {
        // duplicated as String(format:...) not available on Linux
        return self.connection.withConnection { db in
            return db.sql()
                     .select()
                     .column(SQLAlias(SQLRaw("kcu.column_name"), as: SQLRaw("\"columnName\"")))
                     .column(SQLAlias(SQLRaw("c.udt_name"), as: SQLRaw("\"dataType\"")))
                     .column(SQLAlias(SQLRaw("c.is_nullable::BOOLEAN"), as: SQLRaw("\"isNullable\"")))
                     .column(SQLAlias(SQLRaw("ccu.table_name"), as: SQLRaw("\"constrainedTable\"")))
                     .from(SQLAlias(SQLRaw("information_schema.table_constraints"), as: SQLIdentifier("tc")))
                     .join(SQLAlias(SQLRaw("information_schema.columns"), as: SQLRaw("c")),
                                   method: SQLJoinMethod.inner,
                                   on: SQLRaw("c.table_schema = tc.constraint_schema"))
                     .join(SQLAlias(SQLRaw("information_schema.constraint_column_usage"),
                                   as: SQLIdentifier("ccu")),
                                   method: SQLJoinMethod.inner,
                                   on: SQLRaw("tc.constraint_schema = ccu.constraint_schema"))

                     .join(SQLAlias(SQLRaw("information_schema.key_column_usage"), as: SQLRaw("kcu")),
                                   method: SQLJoinMethod.inner,
                                   on: SQLRaw("tc.constraint_name = kcu.constraint_name"))
                     .where(SQLRaw("tc.constraint_name"), .equal, SQLRaw("ccu.constraint_name"))
                     .where(SQLRaw("tc.table_name"), .equal, SQLRaw("c.table_name"))
                     .where(SQLRaw("kcu.column_name"), .equal, SQLRaw("c.column_name"))
                     .where(SQLRaw("constraint_type"), .equal, SQLRaw("'FOREIGN KEY'"))
                     .where(SQLRaw("tc.table_name"), .equal, SQLRaw("'\(table.tableName)'"))
                     .all(decoding: ForeignKey.self)
        }
    }
}
