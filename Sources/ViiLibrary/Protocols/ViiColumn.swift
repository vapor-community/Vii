protocol ViiColumn {
    var columnName: String { get }
    var dataType: String { get }
    var isNullable: Bool { get }

    var swiftVariableName: String { get }

    func getPropertyWrapper() -> String
    func getPropertyDeclaration() -> String
    func getInitializer() -> String
}
