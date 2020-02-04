import XCTest
@testable import ViiLibrary

final class ViiTests: XCTestCase {
    // tests common DB naming conventions
    let expectedOutput = "UserProfile"
    let secondaryOutput = "Userprofile"
    let table = Table(tableName: "user")
    let columns = [
        Column(columnName: "user_id", dataType: "uuid", isNullable: true),
        Column(columnName: "category_id", dataType: "uuid", isNullable: false),
        Column(columnName: "c", dataType: "varchar", isNullable: true),
        Column(columnName: "d", dataType: "_int2", isNullable: false),
        Column(columnName: "e", dataType: "bool", isNullable: true)
    ]
    let primaryKey = DatabaseKey(columnName: "user_id", dataType: "uuid", constraint: DatabaseKey.KeyType.primary, isNullable: true)
    let foreignKeys = [DatabaseKey(columnName: "category_id", dataType: "uuid", constraint: DatabaseKey.KeyType.foreign, isNullable: false)]
    let optionalForeignKeys = [DatabaseKey(columnName: "category_id", dataType: "uuid", constraint: DatabaseKey.KeyType.foreign, isNullable: true)]
        
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
    
    func testClassDeclaration() throws {
        let contents = FileContents(imports: [], originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: [])
        let declaration = contents.classDeclaration
        let expected = "final class User: Model {"
        XCTAssertEqual(declaration, expected)
    }
    
    func testSchemaDeclaration() throws {
        let contents = FileContents(imports: [], originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: [])
        let schema = contents.schema
        let expected = "static let schema = \"\(table.tableName)\""
        XCTAssertEqual(schema, expected)
    }
    
    func testPrimaryKeyWrapper() throws {
        let contents = FileContents(imports: [], originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: [])
        let pk = contents.primaryKeyWrapper
        XCTAssertEqual(pk, "@ID(key: \"user_id\")")
    }
    
    func testPrimaryKeyVariable() throws {
        let contents = FileContents(imports: [], originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: [])
        let pk = contents.primaryKeyVariable
        XCTAssertEqual(pk, "\n\tvar userId: UUID?")
    }
    
    func testForeignKey() throws {
        let contents = FileContents(imports: [], originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: foreignKeys)
        let fk = contents.foreignKeyDeclarations!
        XCTAssertEqual(fk, "\n\t@Parent(key: \"category_id\")\n\tvar categoryId: UUID\n")
    }
    
    func testOptionalForeignKey() throws {
        let contents = FileContents(imports: [], originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: optionalForeignKeys)
        let fk = contents.foreignKeyDeclarations!
        XCTAssertEqual(fk, "\n\t@OptionalParent(key: \"category_id\")\n\tvar categoryId: UUID?\n")
    }

    static var allTests = [
        ("testPascalCaseTable", testPascalCaseTable),
        ("testSpecialChars", testSpecialChars),
        ("testSeparatedColumns", testSeparatedColumns),
        ("testSnakeCaseTable", testSnakeCaseTable),
        ("testSpecialCharsPascal", testSpecialCharsPascal),
        ("testCamelCaseTable", testCamelCaseTable),
        ("testClassDeclaration", testClassDeclaration),
        ("testSchemaDeclaration", testSchemaDeclaration),
        ("testPrimaryKeyWrapper", testPrimaryKeyWrapper),
        ("testPrimaryKeyVariable", testPrimaryKeyVariable),
        ("testForeignKey", testForeignKey),
        ("testOptionalForeignKey", testOptionalForeignKey)
    ]
}
