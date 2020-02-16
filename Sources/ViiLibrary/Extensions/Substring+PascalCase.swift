extension Substring {
    /// Returns the indexes of PascalCase name
    func getPascalCaseIndexes() -> [Int] {
        return self.enumerated().map {
            if true == $1.isUppercase {
                return $0
            }
            return nil
        }
        .compactMap { $0 }
    }

    /// returns PascalCase name using indicies from `getPascalCaseIndexes`
    /// - Parameter indexes: [Int] indicies of Capital letters
    func getPascalCaseName(indicies: [Int]) -> String {
        return self.enumerated().map {
            return indicies.contains($0) ? $1.uppercased() : $1.lowercased()
            }.joined()
    }

    var isUpperCaseString: Bool {
        return isLowerCaseElementsFound() == 0
    }

    /// Returns number of times a lowercase letter is found
    /// 0 times will prove that string is `uppercased`
    func isLowerCaseElementsFound() -> Int {
        return self.map { $0.isUppercase }
                   .filter { $0 == false }
                   .count
    }
}
