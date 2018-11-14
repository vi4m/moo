@testable import App
import FluentPostgreSQL
import Vapor
import XCTest

class AppTests: FunctionalTestCase {
    func testDifferentPasswordsShouldRaiseBadRequest() throws {
        let uu = UserCreateRequest(
            username: "test2", firstName: "test", lastName: "test2",
            email: "test@allegro.pl", password: "123", verifyPassword: "4321"
        )
        XCTAssertThrowsError(try application.sendRequest(to: "/users/sign-up/", method: .POST, body: uu)) { error in
            XCTAssertTrue(error is Abort, "error should be Abort")
            XCTAssertEqual((error as! Abort).identifier, "400")
            XCTAssertEqual((error as! Abort).reason, "Password mismatch")
        }
    }

    func testCreateFeedbackShouldSaveAndReturnFeedback() throws {
        let sender = User(
            id: nil,
            username: "wojtek",
            firstName: "wojtek",
            lastName: "test",
            email: "test",
            passwordHash: "123"
        )
        let recipient = User(
            id: nil,
            username: "arek",
            firstName: "arek",
            lastName: "test2",
            email: "test2",
            passwordHash: "123"
        )
        let senderResult = try sender.save(on: conn).wait()
        let recipientResult = try recipient.save(on: conn).wait()

        let feedback = Feedback(
            id: nil,
            recipientID: recipientResult.id!,
            senderID: senderResult.id!,
            message: "Thank you for helping me!"
        )
        let response = try self.application.client().post(
            "http://localhost:8080/feedbacks/create", content: feedback
        ).wait()

        let savedFeedback = try! response.content.syncDecode(Feedback.self)
        XCTAssertEqual(savedFeedback.message, feedback.message)
        XCTAssertEqual(savedFeedback.senderID, feedback.senderID)
        XCTAssertEqual(savedFeedback.recipientID, feedback.recipientID)
    }

    static let allTests = [
        ("testDifferentPasswordsShouldRaiseBadRequest", testDifferentPasswordsShouldRaiseBadRequest),
    ]
}
