import Foundation

public struct AllCountriesRequest: RequestProtocol {
    typealias Response = [Country]
    var path: String = "all"
    var method: HTTPMethod { .get }
}
