protocol ViiColumn {
    var columnName: String { get }
    var dataType: String { get }
    var isNullable: Bool { get }
}

public struct Column: ViiColumn, Codable, Equatable {
    public var columnName: String
    public var dataType: String
    public var isNullable: Bool
}

public struct ForeignKey: ViiColumn, Codable, Equatable {
    public var columnName: String
    public var dataType: String
    public var isNullable: Bool
    public var constrainedTable: String
    
    func convertToColumn() -> Column {
        return Column(columnName: self.columnName, dataType: self.dataType, isNullable: self.isNullable)
    }
}
