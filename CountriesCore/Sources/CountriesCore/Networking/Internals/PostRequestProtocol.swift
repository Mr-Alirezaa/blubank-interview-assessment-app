import Foundation

protocol PostRequestProtocol: RequestProtocol {
    associatedtype RequestBody: Encodable

    var body: RequestBody { get }
}
