public struct PrimaryKey: ViiColumn, Codable, Equatable {
    public var columnName: String
    public var dataType: String
    public var isNullable: Bool
    
    var swiftVariableName: String {
        return self.columnName.format().lowerCasedFirstLetter()
    }
    
    var toColumn: Column {
        return Column(columnName: self.columnName, dataType: self.dataType, isNullable: self.isNullable)
    }
    
    func getPropertyWrapper() -> String {
        return "@ID(key: \"\(self.columnName)\")"
    }
    
    func getPropertyDeclaration() -> String {
        let dataType = SQLType(self.dataType).swiftType
        return "var \(self.swiftVariableName): \(dataType)?"
    }
}
