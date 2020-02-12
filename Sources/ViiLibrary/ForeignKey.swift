public struct ForeignKey: ViiColumn, Codable {
    public var columnName: String
    public var dataType: String
    public var isNullable: Bool
    public var constrainedTable: String
    
    func convertToColumn() -> Column {
        return Column(columnName: self.columnName, dataType: self.dataType, isNullable: self.isNullable)
    }
}
