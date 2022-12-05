//
//  HomeViewController.swift
//  Countries
//
//  Created by Alireza Asadi on 12/4/22.
//

import UIKit
import CountriesCore
import LocalizationBackport

class HomeViewController: CollectionViewController {
    enum Section {
        case selectedCountries
    }

    enum Row: Hashable {
        case emptyList
        case country(Country)
    }

    var interactor: (any HomeInteractorProtocol)!

    private var dataSource: UICollectionViewDiffableDataSource<Section, Row>!

    override func loadView() {
        super.loadView()
        let image = UIImage(systemName: "plus.circle")?
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(UIColor(named: "AccentColor")!)

        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonTapped))
        navigationItem.rightBarButtonItem = barButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "Home")

        collectionView.registerClass(CountryCell.self)
        collectionView.registerClass(EmptyCell.self)
        collectionView.delegate = self

        let dataSource = makeDataSource(for: collectionView)
        self.dataSource = dataSource

        let snapshot = makeSnapshot(countries: [])
        dataSource.apply(snapshot)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task(priority: .userInitiated) {
            await interactor.update()
        }
    }

    @MainActor func showCountriesList() {
        let controller = CountriesListViewController()
        controller.interactor = CountriesListInteractor(presenter: CountriesListPresenter(controller: controller))
        navigationController?.pushViewController(controller, animated: true)
    }

    @MainActor func updateCollection(with countries: [Country]) {
        let snapshot = makeSnapshot(countries: countries)
        dataSource.apply(snapshot)
    }

    @MainActor func showError(message: String) {
        let alert = UIAlertController(title: String(localized: "Error"), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String(localized: "Dismiss"), style: .default)
        alert.addAction(okAction)

        present(alert, animated: true)
    }

    private func makeDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Row> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Row>(collectionView: collectionView, cellProvider: cellProvider)
        return dataSource
    }

    private func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, item: Row) -> UICollectionViewCell? {
        switch item {
        case .emptyList:
            let cell = collectionView.dequeueReusableCell(EmptyCell.self, for: indexPath)
            cell.onAddButtonTapped {
                Task { @MainActor [weak self] in
                    self?.showCountriesList()
                }
            }
            return cell
        case .country(let country):
            let cell = collectionView.dequeueReusableCell(CountryCell.self, for: indexPath)
            cell.update(using: country)
            return cell
        }
    }

    private func makeSnapshot(countries: [Country]) -> NSDiffableDataSourceSnapshot<Section, Row> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.selectedCountries])
        if countries.isEmpty {
            snapshot.appendItems([.emptyList], toSection: .selectedCountries)
        } else {
            snapshot.appendItems(countries.map(Row.country), toSection: .selectedCountries)
        }
        return snapshot
    }

    @objc private func barButtonTapped(_ barButton: UIBarButtonItem) {
        Task { @MainActor in
            showCountriesList()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {

}
