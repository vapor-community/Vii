public enum ViiDatabaseType {
    case mysql
    case postgres
    case sqlite
}

extension ViiDatabaseType {
    public init?(rawValue: String) {
        switch rawValue {
        case "mysql":
            self = .mysql
        case "postgres":
            self = .postgres
        case "sqlite":
            self = .sqlite
        default:
            return nil
        }
    }
}
