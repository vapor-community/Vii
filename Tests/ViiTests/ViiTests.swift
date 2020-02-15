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
        Column(columnName: "Created_At", dataType: "datetime", isNullable: true),
        Column(columnName: "prefix_MOD_date", dataType: "datetime", isNullable: true),
        Column(columnName: "sys_deletion_dt", dataType: "date", isNullable: false),
        Column(columnName: "abbreviations", dataType: "_char", isNullable: false),
        Column(columnName: "section_id", dataType: "int", isNullable: false),
    ]
    let primaryKey = PrimaryKey(columnName: "user_id", dataType: "uuid", isNullable: true)
    let foreignKeys = [ForeignKey(columnName: "category_id", dataType: "uuid", isNullable: false, constrainedTable: "category")]
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
        XCTAssertEqual(imports, "import Fluent\nimport Vapor\nimport Foundation\n\n")
    }

    func testTrimmedColumns() throws {
        let contents = FileContents(originalTableName: table.tableName, columns: columns, primaryKey: primaryKey, foreignKeys: foreignKeys)
        let trimmedColumns = contents.trimmedColumns
        let expected = [columns[2], columns[3], columns[4], columns[5], columns[6], columns[7], columns[8], columns[9]]
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
    
    func testTimestamps() throws {
        let created = FileContents(originalTableName: table.tableName, columns: [columns[5]], primaryKey: primaryKey, foreignKeys: [])
        let declaration = created.columnProperties!
        XCTAssertEqual(declaration, "\n\t@Timestamp(key: \"Created_At\", on: .create)\n\tvar createdAt: Date?\n")
    }
    
    func testTimeStampModified() throws {
        let modified = FileContents(originalTableName: table.tableName, columns: [columns[6]], primaryKey: primaryKey, foreignKeys: [])
        let declaration = modified.columnProperties!
        XCTAssertEqual(declaration, "\n\t@Timestamp(key: \"prefix_MOD_date\", on: .update)\n\tvar prefixModDate: Date?\n")
    }
    
    func testTimeStampDeleted() throws {
        let deleted = FileContents(originalTableName: table.tableName, columns: [columns[7]], primaryKey: primaryKey, foreignKeys: [])
        let declaration = deleted.columnProperties!
        XCTAssertEqual(declaration, "\n\t@Timestamp(key: \"sys_deletion_dt\", on: .delete)\n\tvar sysDeletionDt: Date?\n")
    }
    
    func testInitializerArgument() throws {
        let nonOptional = columns[1]
        let initializer = nonOptional.getInitializer()
        XCTAssertEqual(initializer, "categoryId: UUID")
    }
    
    func testOptionalInitializerArgument() throws {
        let optional = columns[2]
        let initializer = optional.getInitializer()
        XCTAssertEqual(initializer, "postId: Int? = nil")
    }
    
    func testOptionalArrayInitiazerArgument() throws {
        let nonOptional = columns[4]
        let initializer = nonOptional.getInitializer()
        XCTAssertEqual(initializer, "flags: [Bool]? = nil")
    }
    
    func testArrayInitiazerArgument() throws {
        let nonOptional = columns[8]
        let initializer = nonOptional.getInitializer()
        XCTAssertEqual(initializer, "abbreviations: [String]")
    }
    
    func testPrimaryKeyInitiazerArgument() throws {
        let initializer = primaryKey.getInitializer()
        XCTAssertEqual(initializer, "userId: UUID? = nil")
    }
    
    func testForeignKeyInitializerArguments() throws {
        let initializer = foreignKeys[0].getInitializer()
        XCTAssertEqual(initializer, "categoryId: Category")
    }
    
    func testOptionalForeignKeyInitializerArguments() throws {
        let initializer = optionalForeignKeys[0].getInitializer()
        XCTAssertEqual(initializer, "groupId: Group? = nil")
    }

    func testInitializerSignature() throws {
        let combinedForeignKeys = foreignKeys + optionalForeignKeys
        let selectedColumns = [columns[9], columns[4]]
        let fileContents = FileContents(originalTableName: "UserProfile", columns: selectedColumns, primaryKey: primaryKey, foreignKeys: combinedForeignKeys)
        XCTAssertEqual(fileContents.getInitializerSignature(), "\n\n\tinit(userId: UUID? = nil, categoryId: Category, groupId: Group? = nil, sectionId: Int, flags: [Bool]? = nil){")
    }
    
    func testinitializerBody() throws {
        let twoColumns = [columns[0], columns[1]]
        let body = FileContents(originalTableName: "UserProfile", columns: twoColumns, primaryKey: nil, foreignKeys: [])
        XCTAssertEqual(body.getInitializerBody(), "\n\t\tself.userId = userId\n\t\tself.categoryId = categoryId\n\t}")
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
        ("testArrayProps", testArrayProps),
        ("testTimestamps", testTimestamps),
        ("testTimeStampModified", testTimeStampModified),
        ("testTimeStampDeleted", testTimeStampDeleted),
        ("testInitializerArgument", testInitializerArgument),
        ("testOptionalArrayInitiazerArgument", testOptionalArrayInitiazerArgument),
        ("testPrimaryKeyInitiazerArgument", testPrimaryKeyInitiazerArgument),
        ("testArrayInitiazerArgument", testArrayInitiazerArgument),
        ("testForeignKeyInitializerArguments", testForeignKeyInitializerArguments),
        ("testOptionalForeignKeyInitializerArguments", testOptionalForeignKeyInitializerArguments),
        ("testInitializerSignature", testInitializerSignature),
    ]
}
