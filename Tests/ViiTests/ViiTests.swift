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
        Column(columnName: "post_id", dataType: "int4", isNullable: true),
        Column(columnName: "group_id", dataType: "int4", isNullable: false),
        Column(columnName: "flags", dataType: "_bool", isNullable: true),
        Column(columnName: "Created_At", dataType: "datetime", isNullable: true)
    ]
    let primaryKey = Column(columnName: "user_id", dataType: "uuid", isNullable: true)
    let foreignKeys = [ForeignKey(columnName: "category_id", dataType: "uuid", isNullable: false, constrainedTable: "Category")]
    let optionalForeignKeys = [ForeignKey(columnName: "group_id", dataType: "int4", isNullable: true, constrainedTable: "Group")]
        
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
        let contents = FileContents(originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: [])
        let declaration = contents.classDeclaration
        let expected = "final class User: Model, Content {"
        XCTAssertEqual(declaration, expected)
    }
    
    func testSchemaDeclaration() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: [])
        let schema = contents.schema
        let expected = "static let schema = \"\(table.tableName)\""
        XCTAssertEqual(schema, expected)
    }
    
    func testPrimaryKeyWrapper() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: [])
        let pk = contents.primaryKeyWrapper
        XCTAssertEqual(pk, "@ID(key: \"user_id\")")
    }
    
    func testPrimaryKeyProperty() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: [])
        let pk = contents.primaryKeyProperty!
        XCTAssertEqual(pk, "var userId: UUID?")
    }
    
    func testForeignKey() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: foreignKeys)
        let fk = contents.foreignKeyDeclarations!
        XCTAssertEqual(fk, "\n\n\t@Parent(key: \"category_id\")\n\tvar categoryId: Category")
    }
    
    func testOptionalForeignKey() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: optionalForeignKeys)
        let fk = contents.foreignKeyDeclarations!
        XCTAssertEqual(fk, "\n\n\t@OptionalParent(key: \"group_id\")\n\tvar groupId: Group?")
    }

    func testImports() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: optionalForeignKeys)
        let imports = contents.imports
        XCTAssertEqual(imports, "import Foundation\n\n")
    }

    func testTrimmedColumns() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: foreignKeys)
        let trimmedColumns = contents.trimmedColumns
        let expected = [columns[2],columns[3],columns[4],columns[5]]
        XCTAssertEqual(trimmedColumns, expected)
    }

    func testColumn() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: [columns[3]], primaryKey: nil, foreignKeys: [])
        let declaration = contents.columnProperties!
        XCTAssertEqual(declaration, "\n\t@Field(key: \"group_id\")\n\tvar groupId: Int\n")
    }

    func testArrayProps() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: [columns[4]], primaryKey: nil, foreignKeys: [])
        let declaration = contents.columnProperties!
        XCTAssertEqual(declaration, "\n\t@Field(key: \"flags\")\n\tvar flags: [Bool]?\n")
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
        ("testPrimaryKeyProperty", testPrimaryKeyProperty),
        ("testForeignKey", testForeignKey),
        ("testOptionalForeignKey", testOptionalForeignKey),
        ("testImports", testImports),
        ("testTrimmedColumns", testTrimmedColumns),
        ("testColumn", testColumn),
        ("testArrayProps", testArrayProps)
    ]
}
