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
    private let countryUseCase: CountryUseCase
    private var countries: [Country] = []

    init(presenter: HomePresenter, countryUseCase: CountryUseCase = CountryUseCase()) {
        self.presenter = presenter
        self.countryUseCase = countryUseCase
    }

    func update() async {
        do {
            let selectedCountries = try await countryUseCase.selectedCountries()
            countries = selectedCountries
            await presenter.updateCountriesList(using: selectedCountries)
        } catch {
            // This will not happen.
        }
    }
}
