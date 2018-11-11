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
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func signUp(_ req: Request, content: UserCreateRequest) throws -> Future<UserResponse> {
        guard content.password == content.verifyPassword else {
            throw Abort(.badRequest, reason: "Password mismatch")
        }
            
        let hash = try BCrypt.hash(content.password)
        let user = User(
            id: nil,
            username: content.username,
            firstName: content.firstName,
            lastName: content.lastName,
            email: content.email,
            passwordHash: hash
        )
        return try userRepository.create(user: user).map { user  in
            return try UserResponse(id: user.id!, username: user.username, email: user.email)
        }
    }
}


extension UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("users")
        usersRoute.post(UserCreateRequest.self, at: "sign-up", use: self.signUp)
    }
}
