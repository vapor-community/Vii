import XCTest
import PostgresKit
import NIO
@testable import ViiLibrary

final class ViiDatabaseTests: XCTestCase {
    private var group: EventLoopGroup!
    private var eventLoop: EventLoop {
        return self.group.next()
    }
    private var connection: ViiConnection!
    let credentials = Credential(port: 5432, host: "postgres", username: "vapor", password: "password", database: "vii-test")
    
    override func setUp() {
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.connection = try! ConnectionFactory.getViiConnection(selectedDb: ViiDatabaseType.postgres, eventLoop: self.eventLoop, credentials: credentials)
    }
    
    override func tearDown() {
        XCTAssertNoThrow(try self.group.syncShutdownGracefully())
        self.group = nil
    }
    
    func testGetTables() throws {
        defer { connection.close() }
        let table = try connection.getTables().wait()
        XCTAssertEqual(table.count, 2)
    }
}
