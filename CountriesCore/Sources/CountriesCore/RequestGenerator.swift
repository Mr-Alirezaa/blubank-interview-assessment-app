import Foundation

struct RequestGenerator {
    private var session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func data<R: RequestProtocol>(for request: R) async throws -> R.Response {
        let (data, urlResponse): (Data, URLResponse)
        do {
            (data, urlResponse) = try await session.data(for: request.asURLRequest())
        } catch {
            throw APIError.urlSessionError(underlyingError: error)
        }

        let statusCode = (urlResponse as! HTTPURLResponse).statusCode
        switch statusCode {
        case 200..<400:
            let response = try request.decodeResponse(from: data)
            return response
        case 400..<600:
            throw APIError.httpError(code: statusCode)
        default:
            fatalError("Unknown HTTP Status Code")
        }
    }
}
