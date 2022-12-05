import Foundation

protocol CountryRemoteRepositoryProtocol {
    func allCountries() async throws -> [Country]
}

struct CountryRemoteRepository: CountryRemoteRepositoryProtocol {
    init() {}

    func allCountries() async throws -> [Country] {
        try await RequestGenerator(session: URLSession(configuration: .default)).data(for: AllCountriesRequest())
    }
}
