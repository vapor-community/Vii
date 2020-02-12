public struct FileContents {
    
    var originalTableName: String
    var columns: [Column]
    var primaryKey: Column?
    var foreignKeys: [ForeignKey]

    init(originalTableName: String, columns: [Column], primaryKey: Column?, foreignKeys: [ForeignKey]) {
        self.originalTableName = originalTableName
        self.columns = columns
        self.primaryKey = primaryKey
        self.foreignKeys = foreignKeys
    }
    
    /// computed properties
    /// returns list of any imports
    var imports: String {
        for col in self.columns {
            let sqlType = SQLType(col.dataType)
            if SQLType.foundationRequired.contains(sqlType){
                return "import Foundation\n\n"
            }
        }
        return ""
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
        if let pk = self.primaryKey {
            return self.getPropertyWrapper(column: pk, isPrimary: true, isForeign: false)
        }
        return nil
    }
   
   /// gets property declaration
    var primaryKeyProperty: String? {
        if let pk = self.primaryKey {
            return self.getPropertyDeclaration(column: pk)
        }
        return nil
    }
    
    /// gets primary key declaration
    var primaryKeyDeclaration: String {
        if (self.primaryKey != nil) {
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
        return self.foreignKeys.map { fk in
            let propertyWrapper = self.getPropertyWrapper(column: fk, isPrimary: false, isForeign: true)
            let property = self.getForeignKeyPropertyDeclaration(column: fk)
            return "\n\n\t" + propertyWrapper + "\n\t" + property
        }.joined()
    }

    /// gets formatted foreign key declaration
    var foreignKeyDeclarationsFormatted: String {
        if let fk = self.foreignKeyDeclarations {
            return "\t" + fk
        }
        return ""
    }
    
    /// removes columns used as keys
    var trimmedColumns: [Column] {
        var processedColumns:[Column] = []
        if let pk = self.primaryKey {
            processedColumns.append(pk)
        }
        if !self.foreignKeys.isEmpty {
            processedColumns += self.foreignKeys.compactMap{ fk in
                return fk.convertToColumn()
            }
        }
        return self.columns.filter { !processedColumns.contains($0) }
    }
    
    /// gets declarations for remaining columns
    var columnProperties: String? {
        if self.trimmedColumns.isEmpty { return nil }
        return self.trimmedColumns.map { col in
            let propertyWrapper = self.getPropertyWrapper(column: col, isPrimary: false, isForeign: false)
            let property = self.getPropertyDeclaration(column: col)
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
    
    /// returns propertyWrapper for column
    func getPropertyWrapper<T>(column: T, isPrimary: Bool, isForeign: Bool) -> String where T: ViiColumn {
        if isPrimary {
            return "@ID(key: \"\(column.columnName)\")"
        }
        if isForeign {
            if column.isNullable {
                return "@OptionalParent(key: \"\(column.columnName)\")"
            }
            return "@Parent(key: \"\(column.columnName)\")"
        }
        if SQLType.timestampable.contains(SQLType(column.dataType)){
            return "@Timestamp(key: \"\(column.columnName)\")"
        }
        return "@Field(key: \"\(column.columnName)\")"
    }

    /// returns property declartion and optionality
    func getPropertyDeclaration(column: Column) -> String {
        let dataType = SQLType(column.dataType).swiftType
        let isNullable = column.isNullable ? "?" : ""
        return "var \(column.columnName.format().lowerCasedFirstLetter()): \(dataType)\(isNullable)"
    }
    
    func getForeignKeyPropertyDeclaration(column: ForeignKey) -> String {
        let isNullable = column.isNullable ? "?" : ""
        let formattedVar = column.columnName.format().lowerCasedFirstLetter()
        let tableReference = column.constrainedTable.format()
        return "var \(formattedVar): \(tableReference)\(isNullable)"
    }

    func getInitializer() -> String {
        return "\n\n\tinit() { }"
    }

    /// gets the full initializer
    func getFullInitializer() -> String {
        let initial = "\n\n\tinit("
        let args = self.columns.map { col in
            let dataType = SQLType(col.dataType).swiftType
            let optionality = col.isNullable ? "?," : ","
            return " \(col.columnName.format().lowerCasedFirstLetter()): \(dataType)\(optionality)"
        }.joined()
        let assignment = self.columns.map { col in
            return "\n\t\tself." + col.columnName.format().lowerCasedFirstLetter() + " = " + col.columnName.format().lowerCasedFirstLetter()
        }.joined()
        return initial + args.dropLast() + "){" + assignment + "\n\t}"
    }

    /// returns the file contents
    public func getFileContents() -> String {
        return "import Vapor\n"
                       + imports
                       + classDeclaration
                       + schemaFormatted
                       + primaryKeyDeclarationFormatted
                       + foreignKeyDeclarationsFormatted
                       + columnDeclarationsFormatted
                       + getInitializer()
                       + getFullInitializer()
                       + endDeclaration
    }
}


