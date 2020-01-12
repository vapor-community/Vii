import MySQLKit

public class ViiMySQLConnection: ViiConnection {
    
    public typealias ViiConnectionType = EventLoopFuture<MySQLConnection>
    
    public var connection: EventLoopFuture<MySQLConnection>
    
    public init(eventLoop: EventLoop, credentials: Credential){
        self.connection = MySQLConnection.create(on: eventLoop, credentials: credentials)
    }
}
