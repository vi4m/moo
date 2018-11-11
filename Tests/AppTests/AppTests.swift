import XCTest
@testable import App
import Vapor

class AppTests: FunctionalTestCase {
    func testDifferentPasswordsShouldRaiseBadRequest() throws {
        let uu = UserCreateRequest(username: "test2", firstName: "test", lastName: "test2", email: "test@allegro.pl", password: "123", verifyPassword: "4321")
        
        XCTAssertThrowsError(try application.sendRequest(to: "/users/sign-up/", method: .POST, body: uu)) { error in
            XCTAssertTrue(error is Abort, "error should be Abort")
            XCTAssertEqual((error as! Abort).identifier, "400")
            XCTAssertEqual((error as! Abort).reason, "Password mismatch")
        }
    }
    
    static let allTests = [
        ("testDifferentPasswordsShouldRaiseBadRequest", testDifferentPasswordsShouldRaiseBadRequest),
    ]
}
