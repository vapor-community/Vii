import PostgresKit

class ViiPostgres: Connection {
    public var connection: PostgresConnection

    public init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try PostgresConnection.create(on: eventLoop, credentials: credentials).wait()
    }
}
