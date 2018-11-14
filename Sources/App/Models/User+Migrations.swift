import FluentPostgreSQL
import Vapor

extension User: PostgreSQLMigration {}

struct CreateUniqueUsernameAndEmail: PostgreSQLMigration {
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(User.self, on: conn) { builder in
            builder.deleteUnique(from: \.username)
            builder.deleteUnique(from: \.email)
        }
    }

    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.update(User.self, on: conn) { builder in
            builder.unique(on: \.username)
            builder.unique(on: \.email)
        }
    }
}
