@testable import App
import Vapor
import Authentication

extension Application {
    static func testable() throws -> Application {
        var config = Config.default()
        var services = Services.default()
        var env = Environment.testing
        env.commandInput.arguments = []
        try App.configure(&config, &env, &services)
        let app = try Application(config: config, environment: env, services: services)
        try App.boot(app)
        try app.asyncRun().wait()
        return app
    }
    
    func sendRequest<BodyRequest>(to path: String, method: HTTPMethod, contentType: MediaType = .json, body: BodyRequest) throws -> Response where BodyRequest: Content {
        var http = HTTPRequest(method: method, url: URL(string: path)!)
        http.headers.add(name: .contentType, value: contentType.serialize())
        let req = Request(http: http, using: self)
        try req.content.encode(body)
        let responder = try make(Responder.self)
        return try responder.respond(to: req).wait()
    }
}
