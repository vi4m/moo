import FluentPostgreSQL
import Vapor

struct Feedback: PostgreSQLModel {
    var id: Int?

    var recipientID: Int
    var senderID: Int

    var message: String?

    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: connection) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.recipientID)
            builder.field(for: \.senderID)
            builder.field(for: \.message)
        }
    }
}

extension Feedback: Content {}
extension Feedback: Parameter {}
