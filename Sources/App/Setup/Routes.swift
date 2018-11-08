import Vapor

struct PostgreSQLVersion: Codable {
    let version: String
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // "It works" page
    router.get { req in
        return try req.view().render("welcome")
    }
    
    let usersController = UsersController()
    try router.register(collection: usersController)
    
    router.get("ping") { req in
        return req.withPooledConnection(to: .psql) { conn in
            return conn.raw("SELECT version()")
                .all(decoding: PostgreSQLVersion.self)
            }.map { rows in
                return rows[0].version
        }
    }

}
