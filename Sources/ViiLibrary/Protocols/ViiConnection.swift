import NIO

public protocol ViiConnection: AnyObject {
    
    /// gets all tables for specified database
    func getTables() -> EventLoopFuture<[Table]>
    /// closes current db connection group
    func close()
    /// gets columns and types for  a table
    func getColumns(table: String) -> EventLoopFuture<[Column]>
}