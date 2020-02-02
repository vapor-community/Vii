public struct GenerateFile {
    
    /// gets any imports from the column
    /// - Parameter column: SQLType column
    private static func getImportForColumn(column: SQLType) -> String? {
        if SQLType.foundationArray.contains(column) {
            return "import Foundation\n"
        }
        return nil
    }
    
    private static func getColumnAndWrappers() -> String {
        return ""
    }
    
    public static func generateFileContents(table: Table, columns: [Column], on: ViiConnection) throws -> FileContents {
        var fileImport: [String] = []
        for col in columns {
            let sqlToSwiftType = SQLType(col.dataType)
            if let importFromColumn = self.getImportForColumn(column: sqlToSwiftType) {
                fileImport.append(importFromColumn)
            }
        }
        let uniqueImports = Array(Set(fileImport))
        let primaryKey = try on.getPrimaryKey(table: table).wait()
        let foreignKeys = try on.getForeignKeys(table: table).wait()

        return FileContents(imports: uniqueImports, originalName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: foreignKeys)
    }
}
