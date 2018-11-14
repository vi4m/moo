import FluentPostgreSQL
import Vapor

public func databases(config: inout DatabasesConfig) throws {
    guard let databaseUrl = Environment.get("DATABASE_URL") else {
        throw SetupError.databaseError("DATABASE_URL is empty")
    }
    guard let postgresConfig = PostgreSQLDatabaseConfig(url: databaseUrl) else {
        print("Somethings goes wrong with database configuration")
        throw Abort(.internalServerError)
    }
    let postgres = PostgreSQLDatabase(config: postgresConfig)
    config.add(database: postgres, as: .psql)
    config.enableLogging(on: .psql)
}
