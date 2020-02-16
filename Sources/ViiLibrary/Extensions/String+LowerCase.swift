extension String {
    func lowerCasedFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    mutating func lowerCaseFirstLetter() {
        self = self.lowerCasedFirstLetter()
    }
}
