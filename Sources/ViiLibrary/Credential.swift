public struct Credential {
    public let port: Int
    public let host: String
    public let username: String
    public let password: String
    public let database: String

    public init(port: Int, host: String, username: String, password: String, database: String) {
        self.port = port
        self.host = host
        self.username = username
        self.password = password
        self.database = database
    }
}
