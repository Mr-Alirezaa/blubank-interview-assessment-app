//
//  CountriesListPresenter.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import Foundation
import CountriesCore

final class CountriesListPresenter: Presenter {
    weak var controller: CountriesListViewController?

    init(controller: CountriesListViewController) {
        self.controller = controller
    }

    func beginRefreshing() async {
        await controller?.beginRefreshing()
    }

    func endRefreshing() async {
        await controller?.endRefreshing()
    }

    func updateCountriesList(using countries: [Country]) async {
        await controller?.updateCollection(with: countries)
    }

    func present(error: Error) async {
        await controller?.showError(message: error.localizedDescription)
    }
}
