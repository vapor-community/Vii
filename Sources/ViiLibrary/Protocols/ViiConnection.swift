import NIO

public protocol ViiConnection: AnyObject {
    func getTables(schema: String) -> EventLoopFuture<[ViiTable]>
    func close()
}
