public enum ViiDatabaseType {
    case mysql
    case postgres
}

extension ViiDatabaseType {
    public init?(rawValue: String) {
        switch rawValue {
        case "mysql":
            self = .mysql
        case "postgres":
            self = .postgres
        default:
            return nil
        }
    }
}
