public struct FileContents {
    
    public var imports: [String]
    public var className: String
    public var originalName: String
    //public var dbType: ViiDatabaseType
    
    public init(imports: [String], className: String, originalName: String/*, dbType: ViiDatabaseType*/) {
        self.imports = imports
        self.className = className
        self.originalName = originalName
        //self.dbType = dbType
    }
}

