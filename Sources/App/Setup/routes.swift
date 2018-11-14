import Vapor

struct PostgreSQLVersion: Codable {
    let version: String
}

/// Register your application's routes here.
public func routes(_ router: Router, _ container: Container) throws {
    let userRepository = try container.make(UserRepository.self)
    // "It works" page
    router.get { req in
        return try req.view().render("welcome")
    }

    let usersController = UsersController(userRepository: userRepository)

    let feedbacksController = FeedbacksController()

    try router.register(collection: usersController)
    try router.register(collection: feedbacksController)

    router.get("ping") { req in
        return req.withPooledConnection(to: .psql) { conn in
            conn.raw("SELECT version()")
                .all(decoding: PostgreSQLVersion.self)
        }.map { rows in
            rows[0].version
        }
    }
}
