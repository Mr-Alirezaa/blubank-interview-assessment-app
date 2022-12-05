import Foundation

protocol CountryRepositoryProtocol {
    var localRepo: CountryLocalRepositoryProtocol { get }
    var remoteRepo: CountryRemoteRepositoryProtocol { get }

    func countries() async throws -> [Country]

    func selectedCountries() async throws -> [Country]
    func saveSelectedCountries(_ countries: [Country]) async throws

    @discardableResult func refreshCountriesList() async throws -> [Country]
    func countriesData() async throws -> CountriesData
    func countriesData(selectedCountries: Set<Country>) async throws -> CountriesData 
}

extension CountryRepositoryProtocol {
    func countries() async throws -> [Country] {
        try await countries(forceRefresh: false)
    }

    func countries(forceRefresh: Bool) async throws -> [Country] {
        if !forceRefresh, let localCountries = localRepo.allCountries() {
            return localCountries
        } else {
            return try await refreshCountriesList()
        }
    }

    func selectedCountries() async throws -> [Country] {
        if let localSelectedCountries = localRepo.selectedCountries() {
            return localSelectedCountries
        } else {
            localRepo.saveSelectedCountries([])
            return []
        }
    }

    func saveSelectedCountries(_ countries: [Country]) async throws {
        localRepo.saveSelectedCountries(countries)
    }

    @discardableResult
    func refreshCountriesList() async throws -> [Country] {
        let allCountries = try await remoteRepo.allCountries()
        localRepo.saveCountries(allCountries)
        return allCountries
    }

    func countriesData() async throws -> CountriesData {
        async let countries = countries()
        let selectedCountries = try await Set(selectedCountries())
        return try await countries.reduce(into: [:]) { partialResult, country in
            partialResult[country] = selectedCountries.contains(country)
        }
    }

    func countriesData(selectedCountries: Set<Country>) async throws -> CountriesData {
        let countries = try await countries()
        return countries.reduce(into: [:]) { partialResult, country in
            partialResult[country] = selectedCountries.contains(country)
        }
    }
}

struct CountryRepository: CountryRepositoryProtocol {
    let localRepo: CountryLocalRepositoryProtocol
    let remoteRepo: CountryRemoteRepositoryProtocol

    init(
        localRepository: CountryLocalRepositoryProtocol = CountryLocalRepository(),
        remoteRepository: CountryRemoteRepositoryProtocol = CountryRemoteRepository()
    ) {
        self.localRepo = localRepository
        self.remoteRepo = remoteRepository
    }
}
