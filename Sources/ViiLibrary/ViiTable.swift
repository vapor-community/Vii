public struct ViiTable: Codable {
    public var table_name: String
}

extension ViiTable {
    
    /// splits by non alpha-numeric chars
    var split: [Substring] {
        return self.table_name.split{ !$0.isLetter }
    }
    
    /// Removes non alpha chars
    func stripped() -> String {
        return self.table_name.split{ !$0.isLetter }.joined()
    }
    
    /// formats common naming conventions to Swift class naming conventions where possible
    func format() -> String {
        let components = self.split
        let indicies: [String] = components.map{
            if false == $0.isUpperCaseString {
                // inidices of capital letters
                let indicies = $0.getPascalCaseIndexes()
                // incase camelCase, capitalizingFirstLetter() will make it PascalCase
                return $0.getPascalCaseName(indicies: indicies).capitalizingFirstLetter()
            }
            // string is uppercase, so lowercase and capitalize the 1st letter
            return String($0.lowercased().capitalizingFirstLetter())
        }
        return indicies.joined()
    }
    
}
