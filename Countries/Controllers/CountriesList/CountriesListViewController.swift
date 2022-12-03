//
//  CountriesListViewController.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import UIKit
import SnapKit
import CountriesCore
import LocalizationBackport


class CountriesListViewController: UIViewController {
    private enum Section {
        case countries
    }

    var interactor: (any CountriesListInteractorProtocol)!

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Country>!

    override func loadView() {
        super.loadView()

        let refreshControl = UIRefreshControl()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.oneSectionedList(interRowSpacing: 0))
        view.addSubview(collectionView)

        refreshControl.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
        collectionView.refreshControl = refreshControl

        collectionView.allowsMultipleSelection = true

        self.collectionView = collectionView
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "Countries")

        collectionView.registerClass(CountryCell.self)
        collectionView.delegate = self

        let dataSource = makeDataSource(for: collectionView)
        self.dataSource = dataSource

        Task(priority: .userInitiated) {
            await interactor.initalize()
        }
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

    @MainActor func beginRefreshing() {
        collectionView.refreshControl?.beginRefreshing()
    }

    @MainActor func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }

    @objc private func refreshCollection() {
        Task(priority: .userInitiated) {
            await interactor.refresh()
        }
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Country> {
        let dataSouce = UICollectionViewDiffableDataSource<Section, Country>(collectionView: collectionView, cellProvider: cellProvider)
        return dataSouce
    }

    private func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, item: Country) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(CountryCell.self, for: indexPath)
        cell.update(using: item)
        return cell
    }

    private func makeSnapshot(countries: [Country]) -> NSDiffableDataSourceSnapshot<Section, Country> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.countries])
        snapshot.appendItems(countries, toSection: .countries)
        return snapshot
    }
}

extension CountriesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let country = dataSource.itemIdentifier(for: indexPath) {
            interactor.select(country)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let country = dataSource.itemIdentifier(for: indexPath) {
            interactor.deselect(country)
        }
    }
}
