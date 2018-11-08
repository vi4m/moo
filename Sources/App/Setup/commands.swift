import Vapor

public func commands(config: inout CommandConfig) {
    /// register revert and migrate
    config.useFluentCommands()
}
