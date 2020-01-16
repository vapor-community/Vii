import NIO

public protocol ViiConnection: AnyObject {
    func getTables() -> EventLoopFuture<[ViiTable]>
    func close()
}
