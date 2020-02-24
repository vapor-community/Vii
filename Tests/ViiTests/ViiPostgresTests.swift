import XCTest
import PostgresKit
import NIO
@testable import ViiLibrary

final class ViiPostgresTests: XCTestCase {
    var eventLoopGroup: EventLoopGroup!
    var connection: ViiPostgresConnection!
    let credentials = Credential(port: 5432, host: hostname, username: "vapor", password: "password", database: "vii-test")
    var tables: [Table]!
    
    override func setUp() {
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.connection = try! ViiPostgresConnection(eventLoop: self.eventLoopGroup.next(), credentials: credentials)
        self.tables = try! self.connection.getTables().wait()
    }
    
    override func tearDown() {
        XCTAssertNoThrow(try self.eventLoopGroup.syncShutdownGracefully())
        self.eventLoopGroup = nil
    }

    func testGetTableCount() throws {
        XCTAssertEqual(self.tables.count, 2)
    }
    
    func testArrayColumn() throws {
        let table = self.tables[1]
        let contents = try! GenerateFile.generateFileContents(table: table, connection: self.connection).getFileContents()
        XCTAssertEqual(contents.contains("@Field(key: \"is_array\")"), true)
        XCTAssertEqual(contents.contains("var isArray: [String]?"), true)
    }
}

var hostname: String {
    #if os(Linux)
    return "psql"
    #else
    return "127.0.0.1"
    #endif
}
