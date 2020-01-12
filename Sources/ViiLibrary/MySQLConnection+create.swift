import MySQLKit

extension MySQLConnection {
    static func create(on eventLoop: EventLoop, credentials: Credential) -> EventLoopFuture<MySQLConnection> {
        do {
            return try self.connect(
                to: .makeAddressResolvingHost(credentials.host, port: credentials.port),
                username: credentials.username,
                database: credentials.database,
                password: credentials.password,
                tlsConfiguration: .forClient(certificateVerification: .none),
                on: eventLoop
            )
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
}
