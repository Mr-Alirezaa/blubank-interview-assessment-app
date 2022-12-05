import Foundation

public enum APIError: Error {
    case invalidURL(URL)
    case httpError(code: Int)
    case urlSessionError(underlyingError: Error)

    var localizedDescription: String {
        switch self {
        case .invalidURL(let url):
            return "Unable to create URL by appending path and/or query items to \(url)"
        case .httpError(let code):
            return "Request failed with status code: \(code)"
        case .urlSessionError(let underlyingError):
            return "Unable to send request. error: \(underlyingError.localizedDescription)"
        }
    }
}

