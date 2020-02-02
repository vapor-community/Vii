public struct DatabaseKey: Codable {
    var columnName: String
    var dataType: String
    var constraint: KeyType
    var isNullable: Bool
    
    public enum KeyType: String, Codable {
        case primary
        case foreign
    }
}
