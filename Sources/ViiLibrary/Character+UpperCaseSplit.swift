import Foundation

extension Character {
    func isMember(of set: CharacterSet) -> Bool {
        guard let scalar = UnicodeScalar(String(self)) else { return false }
        return set.contains(scalar)
    }
    
    var isUppercase: Bool {
        return isMember(of: .uppercaseLetters)
    }
}
