import FluentPostgreSQL
import Vapor

final class User: PostgreSQLModel, Content, Parameter {
    var id: Int?
    var username: String
    var firstName: String?
    var lastName: String?
    var email: String
    var passwordHash: String
    
    init(id: Int? = nil, username: String, email: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.email = email
        self.passwordHash = passwordHash
    }
    
    init(id: Int? = nil, username: String, firstName: String?, lastName: String?, email: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
    }
}
