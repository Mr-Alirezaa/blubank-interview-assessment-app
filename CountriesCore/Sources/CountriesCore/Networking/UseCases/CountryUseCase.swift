import Foundation

public struct CountryUseCase {
    private let repository: CountryRepositoryProtocol

    public init() {
        self.repository = CountryRepository()
    }

    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }

    @discardableResult
    public func refreshCountries() async throws -> [Country] {
        try await repository.refreshCountriesList()
    }

    public func countriesData() async throws -> CountriesData {
        try await repository.countriesData()
    }

    public func countriesData(selectedCountries: [Country]) async throws -> CountriesData {
        try await repository.countriesData(selectedCountries: Set(selectedCountries))
    }

    public func selectedCountries() async throws -> [Country] {
        try await repository.selectedCountries()
    }

    public func saveSelectedCountries(_ countries: [Country]) async throws {
        try await repository.saveSelectedCountries(countries)
    }
}
