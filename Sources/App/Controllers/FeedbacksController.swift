import Crypto
import Vapor

final class FeedbacksController {
    func create(_ req: Request, content: Feedback) throws -> Future<Feedback> {
        let feedback = try req.content.decode(Feedback.self).flatMap(to: Feedback.self) { feedback in
            return feedback.save(on: req)
        }
        return feedback
    }
}

extension FeedbacksController: RouteCollection {
    func boot(router: Router) throws {
        let feedbacksRoute = router.grouped("feedbacks")
        feedbacksRoute.post(Feedback.self, at: "create", use: self.create)
    }
}
