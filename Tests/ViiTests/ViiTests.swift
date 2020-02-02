import XCTest
@testable import ViiLibrary

final class ViiTests: XCTestCase {
    // tests common DB naming conventions
    let expectedOutput = "UserProfile"
    let secondaryOutput = "Userprofile"
    let table = Table(tableName: "user")
    let columns = [
        Column(columnName: "user_id", dataType: "uuid", isNullable: true),
        Column(columnName: "b", dataType: "point", isNullable: false),
        Column(columnName: "c", dataType: "varchar", isNullable: true),
        Column(columnName: "d", dataType: "_int2", isNullable: false),
        Column(columnName: "e", dataType: "bool", isNullable: true)
    ]
        
    func testPascalCaseTable() throws {
        let PascalCaseTable = Table(tableName: "UserProfile")
        XCTAssertEqual(PascalCaseTable.tableName.format(), expectedOutput)
    }
    
    func testSpecialChars() throws {
        let specialChars = Table(tableName: "[User Profile]")
        XCTAssertEqual(specialChars.tableName.format(), expectedOutput)
    }
    
    func testSpecialCharsPascal() throws {
        let specialChars = Table(tableName: "[UserProfile]")
        XCTAssertEqual(specialChars.tableName.format(), expectedOutput)
    }
    
    func testSeparatedColumns() throws {
        let separatedColumnNames = Table(tableName: "User_Profile")
        XCTAssertEqual(separatedColumnNames.tableName.format(), expectedOutput)
    }
    
    func testSnakeCaseTable() throws {
        let testSnakeCaseTable = Table(tableName: "user_profile")
        XCTAssertEqual(testSnakeCaseTable.tableName.format(), expectedOutput)
    }
    
    func testCamelCaseTable() throws {
        let testCamelCaseTable = Table(tableName: "userProfile")
        XCTAssertEqual(testCamelCaseTable.tableName.format(), expectedOutput)
    }
    
    func testUpperCaseTable() throws {
        let testUpperCaseTable = Table(tableName: "USERPROFILE")
        XCTAssertEqual(testUpperCaseTable.tableName.format(), secondaryOutput)
    }
    
    func testLowerCaseTable() throws {
        let testLowerCaseTable = Table(tableName: "userprofile")
        XCTAssertEqual(testLowerCaseTable.tableName.format(), secondaryOutput)
    }
    
//    func testFoundationImport() throws {
//        let generator = GenerateFile.generateFileContents(table: table, columns: [columns[0]], on: )
//        let contents = generator.getFileContents().split(separator: "\n")[0]
//        XCTAssertEqual(contents, "import Foundation")
//    }
//
//    func testDeclaration() throws {
//        let generator = GenerateFile.generateFileContents(table: table, columns: [columns[0]])
//        let contents = generator.getFileContents().split(separator: "\n")[1]
//        XCTAssertEqual(contents, "final class User: Model {")
//    }

    static var allTests = [
        ("testPascalCaseTable", testPascalCaseTable),
        ("testSpecialChars", testSpecialChars),
        ("testSeparatedColumns", testSeparatedColumns),
        ("testSnakeCaseTable", testSnakeCaseTable),
        ("testSpecialCharsPascal", testSpecialCharsPascal),
        ("testCamelCaseTable", testCamelCaseTable)
     //   ("testUpperCaseTable", testUpperCaseTable),
       // ("testFoundationImport", testFoundationImport)
    ]
}
