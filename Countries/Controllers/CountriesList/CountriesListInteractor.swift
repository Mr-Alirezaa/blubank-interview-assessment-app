//
//  CountriesListInteractor.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import Foundation
import CountriesCore

protocol CountriesListInteractorProtocol: Interactor where PresenterType == CountriesListPresenter {
    func initialize() async
    func refresh() async
    func saveSelectedCountries()
    
    func isCountrySelected(_ country: Country) -> Bool
    func select(_ country: Country)
    func deselect(_ country: Country)

    func filterCountries(by query: String) async
    func finishSearching() async
}

typealias CountriesData = OrderedDictionary<Country, Bool>

class CountriesListInteractor: CountriesListInteractorProtocol {
    let presenter: CountriesListPresenter
    private let countriesRepo: CountryRepositoryProtocol

    private var countriesData: CountriesData = [:]
    private var selectedCountries: [Country] { countriesData.compactMap { $1 ? $0 : nil } }

    init(presenter: CountriesListPresenter, countriesRepo: CountryRepositoryProtocol = CountryRepository()) {
        self.presenter = presenter
        self.countriesRepo = countriesRepo
    }

    func initialize() async {
        if let localCountries = locallySavedCountries() {
            let selectedCountries = locallySavedSelectedCountries()
            countriesData = createCountriesData(with: localCountries, selectedCountries: Set(selectedCountries))
        } else {
            await presenter.beginRefreshing()
            do {
                let task = Task(priority: .userInitiated) {
                    try await getLatestCountriesList()
                }

                let countries = try await task.value
                saveCountriesToLocalStorage(countries)
                self.countriesData = createCountriesData(with: countries, selectedCountries: [])
            } catch {
                await presenter.present(error: error)
                return
            }
            await presenter.endRefreshing()
        }

        await presenter.updateCountriesList(using: Array(countriesData.keys))
    }

    func refresh() async {
        await presenter.beginRefreshing()
        do {
            let task = Task(priority: .userInitiated) {
                try await getLatestCountriesList()
            }

            let countries = try await task.value
            saveCountriesToLocalStorage(countries)
            self.countriesData = createCountriesData(with: countries, selectedCountries: Set(selectedCountries))
            await presenter.updateCountriesList(using: countries)
        } catch {
            await presenter.present(error: error)
        }
        await presenter.endRefreshing()
    }

    func saveSelectedCountries() {
        saveSelectedCountriesToLocalStorage(selectedCountries)
    }

    func isCountrySelected(_ country: Country) -> Bool {
        countriesData[country] ?? false
    }

    func select(_ country: Country) {
        updateSelectionState(for: country, isSelected: true)
    }

    func deselect(_ country: Country) {
        updateSelectionState(for: country, isSelected: false)
    }

    func filterCountries(by query: String) async {
        let filteredCountries: [Country]
        if #available(iOS 16.0, *) {
            filteredCountries = filterCountriesWithRegex(by: query)
        } else {
            filteredCountries = filterCountriesWithString(by: query)
        }

        if !Task.isCancelled {
            await presenter.updateCountriesList(using: filteredCountries)
        }
    }

    func finishSearching() async {
        await presenter.updateCountriesList(using: Array(countriesData.keys))
    }

    private func updateSelectionState(for country: Country, isSelected: Bool) {
        countriesData[country] = isSelected
    }

    private func getLatestCountriesList() async throws -> [Country] {
        try await countriesRepo.all()
    }

    private func createCountriesData(with countries: [Country], selectedCountries: Set<Country>) -> CountriesData {
        countries.reduce(into: [:]) { $0[$1] = selectedCountries.contains($1) }
    }

    private func locallySavedCountries() -> [Country]? {
        UserDefaults.standard.allCountries
    }

    private func locallySavedSelectedCountries() -> [Country] {
        UserDefaults.standard.selectedCountries ?? []
    }

    private func saveCountriesToLocalStorage(_ countries: [Country]) {
        UserDefaults.standard.allCountries = countries
    }

    private func saveSelectedCountriesToLocalStorage(_ countries: [Country]) {
        UserDefaults.standard.selectedCountries = countries
    }

    @available(iOS 16.0, *)
    private func filterCountriesWithRegex(by query: String) -> [Country] {
        let query: Regex<String> = Regex(verbatim: query).ignoresCase()
        let filteredCountries = countriesData.keys.filter { country in
            country.name.common.contains(query) || country.name.official.contains(query) || country.flagEmoji.contains(query)
        }
        return filteredCountries
    }

    private func filterCountriesWithString(by query: String) -> [Country] {
        let query = query.lowercased()
        let filteredCountries = countriesData.keys.filter { country in
            country.name.common.lowercased().contains(query) || country.name.official.lowercased().contains(query) || country.flagEmoji.contains(query)
        }
        return filteredCountries
    }
}
