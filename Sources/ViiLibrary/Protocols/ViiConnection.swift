import NIO

public protocol ViiConnection: AnyObject {

    /// gets all tables for specified database
    func getTables() -> EventLoopFuture<[Table]>

    /// closes DB connection
    func close()

    /// Returns columns for a given DB table
    /// - Parameter table: `Table` SQL Table
    func getColumns(table: Table) -> EventLoopFuture<[Column]>

    /// Returns primary keys for given DB table
    /// - Parameter table: `Table` SQL Table
    func getPrimaryKey(table: Table) -> EventLoopFuture<PrimaryKey?>

    /// Returns foreign keys for a given DB table
    /// - Parameter table: `Table` SQL Table
    func getForeignKeys(table: Table) -> EventLoopFuture<[ForeignKey]>
}
