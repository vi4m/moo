import Authentication
import Leaf
import PostgreSQL
import Fluent
import FluentPostgreSQL
import Vapor


/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())
    try services.register(FluentPostgreSQLProvider())
    
    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig)
    services.register(databasesConfig)
    
    let poolConfig = DatabaseConnectionPoolConfig(maxConnections: 8)
    services.register(poolConfig)

    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: User.self, database: .psql)
    migrationConfig.add(migration: CreateUniqueUsernameAndEmail.self, database: .psql)
    services.register(migrationConfig)
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
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
