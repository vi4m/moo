import FluentPostgreSQL
import Vapor
import XCTest

@testable import App

class FunctionalTestCase: XCTestCase {
    var application: Application!
    var conn: PostgreSQLConnection!

    override func setUp() {
        super.setUp()
        self.application = try! Application.testable()
        _ = try! self.application!.withNewConnection(to: .psql) { conn in
            return conn.simpleQuery("TRUNCATE \"User\" CASCADE")
                .transform(to: conn.simpleQuery("TRUNCATE \"Feedback\" CASCADE"))
        }.wait()
        self.conn = try! application.newConnection(to: .psql).wait()
    }

    override func tearDown() {
        super.tearDown()
        _ = try! self.application!.withNewConnection(to: .psql) { conn in
            return conn.simpleQuery("TRUNCATE \"User\" CASCADE")
                .transform(to: conn.simpleQuery("TRUNCATE \"Feedback\" CASCADE"))

        }.wait()

        try? self.application.runningServer?.close().wait()
    }
}
