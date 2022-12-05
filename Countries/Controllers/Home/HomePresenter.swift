//
//  HomePresenter.swift
//  Countries
//
//  Created by Alireza Asadi on 12/4/22.
//

import Foundation
import CountriesCore

class HomePresenter: Presenter {
    weak var controller: HomeViewController?

    init(controller: HomeViewController) {
        self.controller = controller
    }

    func updateCountriesList(using countries: [Country]) async {
        await controller?.updateCollection(with: countries)
    }
}
