import XCTest
import PostgresKit
import NIO
@testable import ViiLibrary

final class ViiPostgresTests: XCTestCase {
    private var group: EventLoopGroup!
    private var eventLoop: EventLoop {
        return self.group.next()
    }
    
    let credentials = Credential(port: 5432, host: "psql", username: "vapor", password: "password", database: "vii-test")
    
    override func setUp() {
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }
    
    override func tearDown() {
        XCTAssertNoThrow(try self.group.syncShutdownGracefully())
        self.group = nil
    }

    func testGetTableOutput() throws {
        let connection = try! ConnectionFactory.getViiConnection(selectedDb: ViiDatabaseType.postgres, eventLoop: self.eventLoop, credentials: credentials)
        defer { connection.close() }
        let output = try GenerateFile.generateFileContents(table: Table(tableName: "DemoTable"), connection: connection)
        let classDeclaration = output.classDeclaration
        XCTAssertEqual(classDeclaration, "final class DemoTable: Model, Content {")
    }
}
