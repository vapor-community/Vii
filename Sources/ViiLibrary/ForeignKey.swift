public struct ForeignKey: ViiColumn, Codable {
    public var columnName: String
    public var dataType: String
    public var isNullable: Bool
    public var constrainedTable: String

    var swiftVariableName: String {
        return self.columnName.format().lowerCasedFirstLetter()
    }

    var swiftModelReference: String {
        return self.constrainedTable.format()
    }

    var toColumn: Column {
        return Column(columnName: self.columnName, dataType: self.dataType, isNullable: self.isNullable)
    }

    func getPropertyWrapper() -> String {
        if self.isNullable {
            return "@OptionalParent(key: \"\(self.columnName)\")"
        }
        return "@Parent(key: \"\(self.columnName)\")"
    }

    func getPropertyDeclaration() -> String {
        let isNullable = self.isNullable ? "?" : ""
        return "var \(self.swiftVariableName): \(self.swiftModelReference)\(isNullable)"
    }

    func getInitializer() -> String {
        let isNullable = self.isNullable ? "? = nil" : ""
        return "\(self.swiftVariableName): \(self.swiftModelReference)\(isNullable)"
    }
}
