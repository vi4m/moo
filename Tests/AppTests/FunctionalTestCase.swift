import XCTest
import Vapor
import FluentPostgreSQL

@testable import App

class FunctionalTestCase: XCTestCase {
    var application: Application!
    var conn: PostgreSQLConnection!

    override func setUp() {
        super.setUp()
        self.application = try! Application.testable()
        try! self.application!.withNewConnection(to: .psql) { conn in
            return conn.simpleQuery("TRUNCATE \"User\" CASCADE").transform(to: ())
            }.wait()
        self.conn = try! application.newConnection(to: .psql).wait()
    }

    override func tearDown() {
        super.tearDown()
        try! self.application!.withNewConnection(to: .psql) { conn in
            return conn.simpleQuery("TRUNCATE \"User\" CASCADE").transform(to: ())
        }.wait()
        
        try? self.application.runningServer?.close().wait()
    }
}
