public struct FileContents {
    
    var imports: [String]
    var originalTableName: String
    var columns: [Column]
    var primaryKey: DatabaseKey?
    var foreignKeys: [DatabaseKey]
    
    /// computed
    var className: String {
        return self.originalTableName.format()
    }
    var classDeclaration: String {
        return "final class \(className): Model {"
    }
    var schema: String {
        return "static let schema = \"\(originalTableName)\""
    }
    
    var schemaFormatted: String {
        return "\n\t\(schema)\n"
    }
    var endDeclaration: String {
        return "\n}"
    }
    
    var primaryKeyWrapper: String? {
        if let pk = self.primaryKey {
            return "@ID(key: \"\(pk.columnName)\")"
        }
        return nil
    }
    
    var primaryKeyVariable: String? {
        if let pk = self.primaryKey {
            let colName = pk.columnName.format().lowerCasedFirstLetter()
            let sql = SQLType.init(pk.dataType)
            return "\n\tvar \(colName): \(sql.swiftType)?"
        }
        return nil
    }
    
    var primaryKeyDeclaration: String {
        if (self.primaryKey != nil) {
            return "\n\t" + (self.primaryKeyWrapper ?? "") + (self.primaryKeyVariable ?? "")
        }
        return ""
    }
    
    var primaryKeyDeclarationFormatted: String {
        return "\n\t\(primaryKeyDeclaration)"
    }
    
    var foreignKeyDeclarations: String? {
        if self.foreignKeys.isEmpty { return nil }
        return self.foreignKeys.map { fk in
            let sql = SQLType.init(fk.dataType)
            let isOptional = fk.isNullable ? "@OptionalParent(key: \"\(fk.columnName)\")" : "@Parent(key: \"\(fk.columnName)\")"
            let property = "\n\tvar \(fk.columnName.format().lowerCasedFirstLetter()): \(sql.swiftType)"
            let ending = fk.isNullable ? "?\n" : "\n"
            return "\n\t" + isOptional + property + ending
        }.joined()
    }
    
    /// removes columns used as keys
    var trimmedColumns: [Column] {
        return self.columns.filter( { !$0.columnName.contains("id") })
    }
    
    var columnDeclaration: String {
        return self.trimmedColumns.map { col in
            let swiftType = SQLType.init(col.dataType)
            return "@Field(key: \"\(col.columnName)\")\n\tvar \(col.columnName.format().lowerCasedFirstLetter()): \(swiftType.swiftType)"
        }.joined()
    }
    
    init(imports: [String], originalTableName: String, columns: [Column], primaryKey: DatabaseKey?, foreignKeys: [DatabaseKey]) {
        self.imports = imports
        self.originalTableName = originalTableName
        self.columns = columns
        self.primaryKey = primaryKey
        self.foreignKeys = foreignKeys
    }
    
    public func getFileContents() -> String {
        return imports.joined(separator: "")
                + classDeclaration
                + schemaFormatted
                + primaryKeyDeclaration
                + endDeclaration
    }
}


