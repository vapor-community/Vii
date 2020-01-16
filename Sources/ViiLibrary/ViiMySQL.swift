import MySQLKit

class ViiMySQL: Connection {
    public var connection: MySQLConnection

    public init(eventLoop: EventLoop, credentials: Credential) throws {
        self.connection = try MySQLConnection.create(on: eventLoop, credentials: credentials).wait()
    }
}
