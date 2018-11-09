import XCTest
import Vapor
@testable import App

class FunctionalTestCase: XCTestCase {
    var application: Application!

    override func setUp() {
        super.setUp()
        self.application = try! Application.testable()
    }

    override func tearDown() {
        super.tearDown()
        try! self.application!.withNewConnection(to: .psql) { conn in
            return conn.simpleQuery("TRUNCATE \"User\" CASCADE").transform(to: ())
        }.wait()
    }
}
