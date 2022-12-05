import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}
