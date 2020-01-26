import NIO

public protocol ViiConnection: AnyObject {
    func getTables() -> EventLoopFuture<[ViiTable]>
    func close()
    
}

protocol ViiGenerate {
    func getColumns(table: String) -> EventLoopFuture<[ViiColumn]>
}
