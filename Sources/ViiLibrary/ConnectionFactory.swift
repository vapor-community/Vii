import NIO

/// returns database connection and required methods
public class ConnectionFactory {
    public static func getViiConnection(selectedDb: ViiDatabaseType,
                                        eventLoop: EventLoop,
                                        credentials: Credential) throws -> ViiConnection {
            switch selectedDb {
            case .mysql:
                return try ViiMySQLConnection(eventLoop: eventLoop, credentials: credentials)
            case .postgres:
                return try ViiPostgresConnection(eventLoop: eventLoop, credentials: credentials)
            case .sqlite:
                return try ViiMySQLConnection(eventLoop: eventLoop, credentials: credentials)
            }
        }
}
