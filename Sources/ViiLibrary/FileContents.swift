public struct FileContents {
    
    var imports: [String]
    var originalName: String
    var columns: [Column]
    var primaryKey: DatabaseKey?
    var foreignKeys: [DatabaseKey]
    
    /// computed
    var className: String {
        return self.originalName.format()
    }
    var classDeclaration: String {
        return "\nfinal class \(className): Model {\n"
    }
    var schema: String {
        return "\tstatic let schema = \"\(originalName)\"\n"
    }
    var endDeclaration: String {
        return "\n}"
    }
    
    var primaryKeyDeclaration: String? {
        if let pk = self.primaryKey {
            let sql = SQLType.init(pk.dataType)
            let colName = pk.columnName.format().lowerCasedFirstLetter()
            return "\n\t@ID(key: \"\(pk.columnName)\")\n\tvar \(colName): \(sql.swiftType)"
        }
        return nil
    }
    
    var foreignKeyDeclarations: String? {
        if self.foreignKeys.isEmpty { return nil }
        return self.foreignKeys.map { fk in
            let sql = SQLType.init(fk.dataType)
            let isOptional = fk.isNullable ? "\n\t@OptionalParent(key: \(fk.columnName))" : "\n\t@Parent(key: \"\(fk.columnName)\")"
            let property = "\n\tvar \(fk.columnName): \(sql.swiftType)"
            return "\n\t" + isOptional + property + "\n"
        }.joined()
    }
    
    /// removes columns used as keys
    var trimmedColumns: [Column] {
        return self.columns.filter( { !$0.columnName.contains("id") })
    }
    
    var columnDeclaration: String {
        return self.trimmedColumns.map { col in
            let swiftType = SQLType.init(col.dataType)
            return "\n\t@Field(key: \"\(col.columnName)\")\n\tvar \(col.columnName.format().lowerCasedFirstLetter()): \(swiftType.swiftType)\n"
        }.joined()
    }
    
    init(imports: [String], originalName: String, columns: [Column], primaryKey: DatabaseKey?, foreignKeys: [DatabaseKey]) {
        self.imports = imports
        self.originalName = originalName
        self.columns = columns
        self.primaryKey = primaryKey
        self.foreignKeys = foreignKeys
    }
    
    public func getFileContents() -> String {
        return imports.joined(separator: "")
                + classDeclaration
                + schema
                + (primaryKeyDeclaration ?? "")
                + (foreignKeyDeclarations ?? "")
                + columnDeclaration
                + endDeclaration
    }
}


