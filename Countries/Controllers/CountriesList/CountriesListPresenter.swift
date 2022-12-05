//
//  CountriesListPresenter.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import Foundation
import CountriesCore
import UIKit

final class CountriesListPresenter: Presenter {
    private typealias Section = CountriesListViewController.Section

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
        let snapshot = makeSnapshot(countries: countries)
        await controller?.updateCollection(with: snapshot)
    }

    func present(error: Error) async {
        await controller?.showError(message: error.localizedDescription)
    }

    private func makeSnapshot(countries: [Country]) -> NSDiffableDataSourceSnapshot<Section, Country> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.countries])
        snapshot.appendItems(countries, toSection: .countries)
        return snapshot
    }
}
