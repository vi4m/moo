import FluentPostgreSQL
import Vapor

struct User: PostgreSQLModel, Content, Parameter {
    var id: Int?
    var username: String
    var firstName: String?
    var lastName: String?
    var email: String
    var passwordHash: String
}
