//
//  CountriesListInteractor.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import Foundation
import CountriesCore

protocol CountriesListInteractorProtocol: Interactor where PresenterType == CountriesListPresenter {
    func initalize() async
    func refresh() async
    func select(_ country: Country)
    func deselect(_ country: Country)
}

class CountriesListInteractor: CountriesListInteractorProtocol {
    let presenter: CountriesListPresenter
    private let countriesRepo: CountryRepositoryProtocol

    private var countries: [Country] = []

    init(presenter: CountriesListPresenter, countriesRepo: CountryRepositoryProtocol = CountryRepository()) {
        self.presenter = presenter
        self.countriesRepo = countriesRepo
    }

    func initalize() async {
        if let localCountries = locallySavedCountries() {
            countries = localCountries
        } else {
            do {
                let task = Task(priority: .userInitiated) {
                    try await getLatestCountriesList()
                }

                let countries = try await task.value
                self.countries = countries
            } catch {
                await presenter.present(error: error)
                return
            }
        }

        await presenter.updateCountriesList(using: countries)
    }

    func refresh() async {
        await presenter.beginRefreshing()
        do {
            let task = Task(priority: .userInitiated) {
                try await getLatestCountriesList()
            }

            let countries = try await task.value
            saveToLocalStorage(countries: countries)
            await presenter.updateCountriesList(using: countries)
        } catch {
            await presenter.present(error: error)
        }
        await presenter.endRefreshing()
    }

    func select(_ country: Country) {

    }

    func deselect(_ country: Country) {

    }

    private func getLatestCountriesList() async throws -> [Country] {
        try await countriesRepo.all()
    }

    private func locallySavedCountries() -> [Country]? {
        UserDefaults.standard.allCountries
    }

    private func saveToLocalStorage(countries: [Country]) {
        UserDefaults.standard.allCountries = countries
    }
}
