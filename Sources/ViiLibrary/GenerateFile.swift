public struct GenerateFile {
    
    /// gets any imports from the column
    /// - Parameter column: SQLType column
    static func getImportForColumn(column: SQLType) -> String? {
        if SQLType.foundationArray.contains(column) {
            return "import Foundation\n"
        }
        return nil
    }
    
    public static func generateFileContents(table: Table, columns: [Column]) -> FileContents {
        var fileImport: [String] = []
        columns.map { col in
            let sqlToSwiftType = SQLType(col.dataType)
            if let importFromColumn = self.getImportForColumn(column: sqlToSwiftType) {
                fileImport.append(importFromColumn)
            }
        }
        let uniqueImports = Array(Set(fileImport))
        return FileContents(imports: uniqueImports, className: table.format(), originalName: table.tableName)
    }
}
