import XCTest
@testable import ViiLibrary

final class ViiTests: XCTestCase {
    // tests common DB naming conventions
    let expectedOutput = "UserProfile"
    let secondaryOutput = "Userprofile"
        
    func testPascalCaseTable() throws {
        let PascalCaseTable = ViiTable(table_name: "UserProfile")
        XCTAssertEqual(PascalCaseTable.format(), expectedOutput)
    }
    
    func testSpecialChars() throws {
        let specialChars = ViiTable(table_name: "[User Profile]")
        XCTAssertEqual(specialChars.format(), expectedOutput)
    }
    
    func testSpecialCharsPascal() throws {
        let specialChars = ViiTable(table_name: "[UserProfile]")
        XCTAssertEqual(specialChars.format(), expectedOutput)
    }
    
    func testSeparatedColumns() throws {
        let separatedColumnNames = ViiTable(table_name: "User_Profile")
        XCTAssertEqual(separatedColumnNames.format(), expectedOutput)
    }
    
    func testSnakeCaseTable() throws {
        let testSnakeCaseTable = ViiTable(table_name: "user_profile")
        XCTAssertEqual(testSnakeCaseTable.format(), expectedOutput)
    }
    
    func testCamelCaseTable() throws {
        let testCamelCaseTable = ViiTable(table_name: "userProfile")
        XCTAssertEqual(testCamelCaseTable.format(), expectedOutput)
    }
    
    func testUpperCaseTable() throws {
        let testUpperCaseTable = ViiTable(table_name: "USERPROFILE")
        XCTAssertEqual(testUpperCaseTable.format(), secondaryOutput)
    }
    
    func testLowerCaseTable() throws {
        let testLowerCaseTable = ViiTable(table_name: "userprofile")
        XCTAssertEqual(testLowerCaseTable.format(), secondaryOutput)
    }

    static var allTests = [
        ("testPascalCaseTable", testPascalCaseTable),
        ("testSpecialChars", testSpecialChars),
        ("testSeparatedColumns", testSeparatedColumns),
        ("testSnakeCaseTable", testSnakeCaseTable),
        ("testSpecialCharsPascal", testSpecialCharsPascal),
        ("testCamelCaseTable", testCamelCaseTable),
        ("testUpperCaseTable", testUpperCaseTable)
    ]
}
