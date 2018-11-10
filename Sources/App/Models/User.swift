import FluentPostgreSQL
import Vapor

struct User: PostgreSQLModel, Content, Parameter {
    var id: Int? = nil
    var username: String
    var firstName: String? = nil
    var lastName: String? = nil
    var email: String
    var passwordHash: String
}
