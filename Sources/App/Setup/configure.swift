import Authentication
import Fluent
import FluentPostgreSQL
import Leaf
import PostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())
    try services.register(FluentPostgreSQLProvider())

    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig)
    services.register(databasesConfig)

    setupRepositories(services: &services, config: &config)

    let poolConfig = DatabaseConnectionPoolConfig(maxConnections: 8)
    services.register(poolConfig)

    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: User.self, database: .psql)
    migrationConfig.add(migration: CreateUniqueUsernameAndEmail.self, database: .psql)
    migrationConfig.add(model: Feedback.self, database: .psql)

    services.register(migrationConfig)

    /// Register routes to the router
    services.register(Router.self) { container -> EngineRouter in
        let router = EngineRouter.default()
        try routes(router, container)
        return router
    }

    /// Use Leaf for rendering views
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)

    var middlewaresConfig = MiddlewareConfig()
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)

    var commandsConfig = CommandConfig.default()
    commands(config: &commandsConfig)
    services.register(commandsConfig)
}
