public class AnyViiConnection<ErasedConnectionType>: ViiConnection {
    public var connection: ErasedConnectionType
    
    public init<Injected: ViiConnection>(_ connect: Injected) where Injected.ViiConnectionType == ErasedConnectionType{
        connection = connect.connection
    }
}

import NIO
//public class ConnectionFactory {
//    static func getViiConnection(_ selectedDb: ViiDatabaseType, eventLoop: EventLoop, credentials: Credential) -> AnyViiConnection<Any> {
//        switch selectedDb {
//        case .mysql:
//            return AnyViiConnection(ViiMySQLConnection(eventLoop: eventLoop, credentials: credentials))
//        case .postgres:
//            return AnyViiConnection(ViiPostgresConnection(eventLoop: eventLoop, credentials: credentials))
//        case .sqlite:
//            return AnyViiConnection(ViiPostgresConnection(eventLoop: eventLoop, credentials: credentials))
//        }
//    }
//}
