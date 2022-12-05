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
    func saveSelectedCountries() async
    
    func isCountrySelected(_ country: Country) -> Bool
    func select(_ country: Country)
    func deselect(_ country: Country)

    func filterCountries(by query: String) async
    func finishSearching() async
}

class CountriesListInteractor: CountriesListInteractorProtocol {
    let presenter: CountriesListPresenter
    private let countryUseCase: CountryUseCase

    private var countriesData: CountriesData = [:]
    private var selectedCountries: [Country] { countriesData.compactMap { $1 ? $0 : nil } }

    init(presenter: CountriesListPresenter, countryUseCase: CountryUseCase = CountryUseCase()) {
        self.presenter = presenter
        self.countryUseCase = countryUseCase
    }

    func initialize() async {
        do {
            await presenter.beginRefreshing()

            let countriesData = try await countryUseCase.countriesData()
            self.countriesData = countriesData

            await presenter.updateCountriesList(using: Array(countriesData.keys))
            await presenter.endRefreshing()
        } catch {
            await presenter.endRefreshing()
            await presenter.present(error: error)
        }
    }

    func refresh() async {
        do {
            await presenter.beginRefreshing()
            try await countryUseCase.refreshCountries()

            let countriesData = try await countryUseCase.countriesData(selectedCountries: selectedCountries)
            self.countriesData = countriesData

            await presenter.updateCountriesList(using: Array(countriesData.keys))
            await presenter.endRefreshing()
        } catch {
            await presenter.endRefreshing()
            await presenter.present(error: error)
        }
    }

    func saveSelectedCountries() async {
        do {
            try await countryUseCase.saveSelectedCountries(selectedCountries)
        } catch {
            // This will not happen
        }
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
