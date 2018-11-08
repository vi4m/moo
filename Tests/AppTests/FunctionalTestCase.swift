import XCTest
import Vapor
@testable import App

class FunctionalTestCase: XCTestCase {
    var a: Application!

    override func setUp() {
        super.setUp()
        self.a = try! Application.testable()
    }

    override func tearDown() {
        super.tearDown()
//        try! self.a!.withNewConnection(to: .psql) { conn in
//            return conn.simpleQuery("DROP DATABASE kudosy_test").transform(to: ())
//        }.wait()
    }
}
