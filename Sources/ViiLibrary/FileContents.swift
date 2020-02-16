public struct FileContents {

    var originalTableName: String
    var columns: [Column]
    var primaryKey: PrimaryKey?
    var foreignKeys: [ForeignKey]

    init(originalTableName: String, columns: [Column], primaryKey: PrimaryKey?, foreignKeys: [ForeignKey]) {
        self.originalTableName = originalTableName
        self.columns = columns
        self.primaryKey = primaryKey
        self.foreignKeys = foreignKeys
    }

    /// computed properties
    /// returns list of any imports
    var imports: String {
        var modulesToImport = "import Fluent\nimport Vapor\n"
        for column in self.columns {
            let sqlType = SQLType(column.dataType)
            if SQLType.foundationRequired.contains(sqlType) {
                modulesToImport += "import Foundation\n\n"
                return modulesToImport
            }
        }
        return modulesToImport
    }

    /// gets swift naming convention ClassName
    public var className: String {
        return self.originalTableName.format()
    }

    /// gets class name declaration
    var classDeclaration: String {
        return "final class \(self.className): Model, Content {"
    }

    /// gets the schema declaration
    var schema: String {
        return "static let schema = \"\(self.originalTableName)\""
    }

    /// gets the fromatted schema
    var schemaFormatted: String {
        return "\n\t\(self.schema)\n"
    }

    /// gets closing declaration
    var endDeclaration: String {
        return "\n}"
    }

    /// gets property wrapper for primary key    
    var primaryKeyWrapper: String? {
        if let primaryKey = self.primaryKey {
            return self.getPropertyWrapper(column: primaryKey)
        }
        return nil
    }

   /// gets property declaration
    var primaryKeyProperty: String? {
        if let primaryKey = self.primaryKey {
            return self.getPropertyDeclaration(column: primaryKey)
        }
        return nil
    }

    /// gets primary key declaration
    var primaryKeyDeclaration: String {
        if self.primaryKey != nil {
            return (self.primaryKeyWrapper ?? "") + "\n\t" + (self.primaryKeyProperty ?? "")
        }
        return ""
    }

    /// gets formatted primary key declaration
    var primaryKeyDeclarationFormatted: String {
        return "\n\t\(self.primaryKeyDeclaration)"
    }

    /// gets declarations for forign keys
    var foreignKeyDeclarations: String? {
        if self.foreignKeys.isEmpty { return nil }
        return self.foreignKeys.map { foreignKey in
            let propertyWrapper = self.getPropertyWrapper(column: foreignKey)
            let property = self.getPropertyDeclaration(column: foreignKey)
            return "\n\n\t" + propertyWrapper + "\n\t" + property
        }.joined()
    }

    /// gets formatted foreign key declaration
    var foreignKeyDeclarationsFormatted: String {
        if let foreignKey = self.foreignKeyDeclarations {
            return "\t" + foreignKey
        }
        return ""
    }

    /// removes columns used as keys
    var trimmedColumns: [Column] {
        var processedColumns: [Column] = []
        if let primaryKey = self.primaryKey {
            processedColumns.append(primaryKey.toColumn)
        }
        if !self.foreignKeys.isEmpty {
            for foreignKey in self.foreignKeys {
                processedColumns.append(foreignKey.toColumn)
            }
        }
        return self.columns.filter { !processedColumns.contains($0) }
    }

    /// gets declarations for remaining columns
    var columnProperties: String? {
        if self.trimmedColumns.isEmpty { return nil }
        return self.trimmedColumns.map { column in
            let propertyWrapper = self.getPropertyWrapper(column: column)
            let property = self.getPropertyDeclaration(column: column)
            return "\n\t" + propertyWrapper + "\n\t" + property + "\n"
        }.joined()
    }

    /// gets formatted column declaration
    var columnDeclarationsFormatted: String {
        if let columnDeclarations = self.columnProperties {
            return "\n\t" + columnDeclarations
        }
        return ""
    }

    /// Takes a `ViiColumn` returns the property wrapper declaration
    /// - Parameter column: `ViiColumn`
    /// - returns: `String` representation of `@propertyWrapper`
    func getPropertyWrapper<T>(column: T) -> String where T: ViiColumn {
        return column.getPropertyWrapper()
    }

    /// returns property declartion and optionality
    func getPropertyDeclaration<T>(column: T) -> String where T: ViiColumn {
        return column.getPropertyDeclaration()
    }

    func getInitializer() -> String {
        return "\n\n\tinit() { }"
    }

    /// gets the initializer signature
    func getInitializerSignature() -> String {
        var startInit = "\n\n\tinit("
        if let primaryKey = self.primaryKey?.getInitializer() {
            startInit += "\(primaryKey), "
        }
        let foreignKeyArgs: String = self.foreignKeys.map { foreignKey in
            return "\(foreignKey.getInitializer()), "
        }.joined()
        let columnArgs: String = self.trimmedColumns.enumerated().map { (offset: Int, element: Column) -> String in
            offset == self.trimmedColumns.count - 1 ? element.getInitializer() : "\(element.getInitializer()), "
        }.joined()
        return "\(startInit)\(foreignKeyArgs)\(columnArgs)){"
    }

    func getInitializerBody() -> String {
        let body = self.columns.map { column in
            return "\n\t\tself.\(column.swiftVariableName) = \(column.swiftVariableName)"
        }
        return "\(body.joined())\n\t}"
    }

    func getFullInitializer() -> String {
        return "\(self.getInitializerSignature())\(self.getInitializerBody())"
    }

    /// returns the file contents
    public func getFileContents() -> String {
        return """
        \(imports) \(classDeclaration) \(schemaFormatted) \(primaryKeyDeclarationFormatted)
        \(foreignKeyDeclarationsFormatted) \(columnDeclarationsFormatted) \(getInitializer())
        \(getFullInitializer()) \(endDeclaration)
        """
    }
}
