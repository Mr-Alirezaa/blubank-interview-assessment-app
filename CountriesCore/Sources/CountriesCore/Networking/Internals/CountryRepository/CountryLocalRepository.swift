import Foundation

protocol CountryLocalRepositoryProtocol {
    func allCountries() -> [Country]?
    func selectedCountries() -> [Country]?
    func saveCountries(_ countries: [Country])
    func saveSelectedCountries(_ countries: [Country])
}

struct CountryLocalRepository: CountryLocalRepositoryProtocol {
    init() {}

    func allCountries() -> [Country]? {
        UserDefaults.standard.allCountries
    }

    func selectedCountries() -> [Country]? {
        UserDefaults.standard.selectedCountries
    }

    func saveCountries(_ countries: [Country]) {
        UserDefaults.standard.allCountries = countries
    }

    func saveSelectedCountries(_ countries: [Country]) {
        UserDefaults.standard.selectedCountries = countries
    }
}
