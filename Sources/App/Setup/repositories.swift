import Vapor

public func setupRepositories(services: inout Services, config: inout Config) {
    services.register(PostgreSQLUserRepository.self)
    preferDatabaseRepositories(config: &config)
}

private func preferDatabaseRepositories(config: inout Config) {
    config.prefer(PostgreSQLUserRepository.self, for: UserRepository.self)
}
