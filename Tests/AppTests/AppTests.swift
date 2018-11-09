import XCTest
@testable import App
import Vapor

class AppTests: FunctionalTestCase {
    func testDifferentPasswordsShouldRaiseBadRequest() throws {
        let uu = UserCreateRequest(username: "test2", firstName: "test", lastName: "test2", email: "test@allegro.pl", password: "123", verifyPassword: "4321")
        let response = try application.sendRequest(to: "/users/sign-up/", method: .POST, body: uu)
        try XCTAssertThrowsError(response.content.decode(String.self))
    }
    
    static let allTests = [
        ("testDifferentPasswordsShouldRaiseBadRequest", testDifferentPasswordsShouldRaiseBadRequest),
    ]
}
