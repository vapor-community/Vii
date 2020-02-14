import Foundation

public struct Column: ViiColumn, Codable, Equatable {
    public var columnName: String
    public var dataType: String
    public var isNullable: Bool
    
    var swiftDataType: String {
        return SQLType(self.dataType).swiftType
    }

    var swiftVariableName: String {
        return self.columnName.format().lowerCasedFirstLetter()
    }
    
    func isTimestamp() -> Bool {
        if SQLType.timestampable.contains(SQLType(self.dataType)) { return true }
        return false
    }
   
    func getPropertyWrapper() -> String {
        if isTimestamp() {
            let triggerEnumCase = self.getTimestampEnumeration()
            return "@Timestamp(key: \"\(self.columnName)\", on: \(triggerEnumCase))"
        }
        return "@Field(key: \"\(self.columnName)\")"
    }
    
    func getPropertyDeclaration() -> String {
        let propertyDataType = SQLType.potsgresArray.contains(SQLType(self.dataType)) ? "[\(self.swiftDataType)]" : self.swiftDataType
        let isNullable = self.isNullable || self.isTimestamp() ? "?" : ""
        return "var \(self.swiftVariableName): \(propertyDataType)\(isNullable)"
    }
    
    private func getTimestampEnumeration() -> String {
        let deleted = NSRegularExpression("(deleted|del)")
        let updated = NSRegularExpression("(update|mod)")
        if deleted.matches(self.columnName.lowercased()) {
            return ".delete"
        } else if updated.matches(self.columnName.lowercased()) {
            return ".update"
        }
        return ".create"
    }
}

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

