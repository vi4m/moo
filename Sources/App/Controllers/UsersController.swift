import Crypto
import Vapor


struct UserCreateRequest: Content {
    var username: String
    var firstName: String?
    var lastName: String?
    var email: String
    var password: String
    var verifyPassword: String
}

struct UserResponse: Content {
    var id: Int
    var username: String
    var email: String
}

final class UsersController {
    func login(_ req: Request) throws -> Future<User> {
        print(req.parameters)
        try req.client().get("https://source.net.pl/")
        return try req.parameters.next(User.self)
//        return try User.query(on: req).filter(\.username == "123").all()
    }
    
    func signUp(_ req: Request) throws -> Future<UserResponse> {
        return try req.content.decode(UserCreateRequest.self).flatMap { user -> Future<User> in
            guard user.password == user.verifyPassword else {
                throw Abort(.badRequest, reason: "Password mismatch")
            }
            let hash = try BCrypt.hash(user.password)
            return User(
                username: user.username,
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                passwordHash: hash
                ).save(on: req).catch() { error in
                    print(error)
            }
        }.map { user in
            return try UserResponse(id: user.id!, username: user.username, email: user.email)
        }
    }
    
    func setup(_ req: Request) throws -> Future<String> {
        return User(id: nil, username: "test_1234", email: "test", passwordHash: "asd").save(on: req).map(to: String.self) { _ in
            return "aaa"
        }.catchMap { error in
            return "errr"
        }
    }
}


extension UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("users")
        usersRoute.get("_setup", use: setup)
        usersRoute.get("login", User.parameter, use: login)
        usersRoute.post("sign-up", use: signUp)
    }
}
