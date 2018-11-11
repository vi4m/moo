import FluentPostgreSQL
import Vapor


protocol UserRepository: ServiceType {
    func create(user: User) throws -> Future<User>
}

final class PostgreSQLUserRepository: UserRepository {
    let db: PostgreSQLDatabase.ConnectionPool

    init(_ db: PostgreSQLDatabase.ConnectionPool) {
        self.db = db
    }

    func create(user: User) -> EventLoopFuture<User> {
        return db.withConnection { conn in
            return user.save(on: conn)
        }
    }
}

extension PostgreSQLUserRepository {
    static let serviceSupports: [Any.Type] = [UserRepository.self]

    static func makeService(for worker: Container) throws -> Self {
        return .init(try worker.connectionPool(to: .psql))
    }
}

extension Database {
    public typealias ConnectionPool = DatabaseConnectionPool<ConfiguredDatabase<Self>>
}
