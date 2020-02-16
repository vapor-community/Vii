import PostgresKit

extension PostgresConnection {
    static func create(on eventLoop: EventLoop, credentials: Credential) -> EventLoopFuture<PostgresConnection> {
        do {
            let address: SocketAddress
            #if os(Linux)
            address = try .makeAddressResolvingHost("localhost", port: credentials.port)
            #else
            address = try .init(ipAddress: credentials.host, port: credentials.port)
            #endif
            return connect(to: address, on: eventLoop).flatMap { conn in
                return conn.authenticate(username: credentials.username,
                                         database: credentials.database,
                                         password: credentials.password)
                                    .map { conn }
            }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
}

var hostname: String {
    #if os(Linux)
    return "psql"
    #else
    return "127.0.0.1"
    #endif
}
