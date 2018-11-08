import XCTest
@testable import App
import Vapor

class AppTests: FunctionalTestCase {
    func testStub() throws {
//        let uu = UserCreateRequest(username: "test2", firstName: "test", lastName: "test2", email: "asd2@sdf.pl", password: "123", verifyPassword: "123")
//        let response = try application.sendRequest(to: "/users/sign-up/", method: .POST, body: uu)
//        try print(response.content.decode(UserResponse.self))
    }
    
    static let allTests = [
        ("testStub", testStub),
    ]
}
