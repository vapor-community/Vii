public struct ViiFile {
    let imports: ViiImport?
    let name: String
    let originalName: String
    let dbType: ViiDatabaseType
}

struct ViiImport {
    let imports: [String]
}
