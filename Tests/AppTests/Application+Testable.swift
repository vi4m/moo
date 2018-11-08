@testable import App
import Vapor
import Authentication

extension Application {
    static func testable() throws -> Application {
        var config = Config.default()
        var services = Services.default()
        var env = Environment.testing
        try App.configure(&config, &env, &services)
        let app = try Application(config: config, environment: env, services: services)
        try App.boot(app)

        return app
    }

    func sendRequest<BodyRequest>(to path: String, method: HTTPMethod, contentType: MediaType = .json, body: BodyRequest) throws -> Response where BodyRequest: Content {
        var http = HTTPRequest(method: method, url: URL(string: path)!)
        http.headers.add(name: .contentType, value: contentType.serialize())
        let req = Request(http: http, using: self)
        try req.content.encode(body)
        let responder = try make(Responder.self)
        return try responder.respond(to: req).wait()

//        var httpRequest = HTTPRequest(method: method, url: URL(string: path)!)
//        httpRequest.headers.add(name: .contentType, value: contentType.serialize())
//        let responder = try! self.make(Responder.self)
//        let wrappedRequest = Request(http: httpRequest, using: self)
//        return try! responder.respond(to: wrappedRequest).wait()
//        var httpRequest = HTTPRequest(method: method, url: URL(string: path)!)
//        httpRequest.headers.add(name: .contentType, value: contentType.serialize())
//        return Request(http: httpRequest, using: self)

//        let responder = try make(Responder.self)
//        return try responder.respond(to: wrappedRequest).wait()
    }
}
