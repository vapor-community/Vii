import NIO

protocol ViiGetTables {
    func getTables(schema: String?, skip: [String]?) -> EventLoopFuture<[ViiTable]>
}

protocol ViiPrimaryKeys {
    func getPrimaryKeys()
}

protocol ViiForeignKeys {
    func getForeignKeys()
}

protocol ViiStandardColumns {
    func getStandardColumns()
}
