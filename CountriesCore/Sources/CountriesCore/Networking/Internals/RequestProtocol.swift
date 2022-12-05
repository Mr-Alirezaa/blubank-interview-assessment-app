import Foundation

protocol RequestProtocol: URLRequestConvertible {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var decoder: JSONDecoder { get }
}

extension RequestProtocol {
    var baseURL: URL { URL(string: "https://restcountries.com/v3.1")! }
    var queryParameters: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    var decoder: JSONDecoder { JSONDecoder() }

    func asURLRequest() throws -> URLRequest {
        let baseURL = baseURL
            .appendingPathComponent(path)

        guard var urlComponents = URLComponents(string: baseURL.absoluteString) else {
            throw APIError.invalidURL(baseURL)
        }

        urlComponents.queryItems = queryParameters

        guard let url = urlComponents.url else {
            throw APIError.invalidURL(baseURL)
        }

        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return request
    }
}

extension RequestProtocol {
    func decodeResponse(from data: Data) throws -> Response {
        try decoder.decode(Response.self, from: data)
    }
}
