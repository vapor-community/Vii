public struct GenerateFile {

public static func generateFileContents(table: Table, connection: ViiConnection) throws -> FileContents {

        let columns = try connection.getColumns(table: table).wait()
        let primaryKey = try connection.getPrimaryKey(table: table).wait()
        let foreignKeys = try connection.getForeignKeys(table: table).wait()

        return FileContents(originalTableName: table.tableName,
                                               columns: columns,
                                               primaryKey: primaryKey,
                                               foreignKeys: foreignKeys)
    }
}
