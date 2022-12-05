//
//  HomeInteractor.swift
//  Countries
//
//  Created by Alireza Asadi on 12/4/22.
//

import Foundation
import CountriesCore

protocol HomeInteractorProtocol: Interactor where PresenterType == HomePresenter {
    func update() async
}

class HomeInteractor: HomeInteractorProtocol {
    let presenter: HomePresenter
    private var countries: [Country]

    init(presenter: HomePresenter, countries: [Country] = []) {
        self.presenter = presenter
        self.countries = countries
    }

    func update() async {
        let selectedCountries = selectedCountries()
        countries = selectedCountries
        await presenter.updateCountriesList(using: selectedCountries)
    }

    private func selectedCountries() -> [Country] {
        if let selectedCountries = UserDefaults.standard.selectedCountries {
            return selectedCountries
        }
        UserDefaults.standard.selectedCountries = []
        return []
    }
}
