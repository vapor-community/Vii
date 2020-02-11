public struct Column: Codable, Equatable {
    public var columnName: String
    public var dataType: String
    public var isNullable: Bool
}

public struct ForeignKey: Codable, Equatable {
    public var columnName: String
    public var dataType: String
    public var isNullable: Bool
    public var constrainedTable: String?
}
