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


class CountriesListViewController: CollectionViewController {
    enum Section {
        case countries
    }

    var interactor: (any CountriesListInteractorProtocol)!

    private(set) var dataSource: UICollectionViewDiffableDataSource<Section, Country>!

    private var searchController: UISearchController!

    private var searchTask: Task<Void, Never>?

    override func loadView() {
        super.loadView()
        let image = UIImage(systemName: "magnifyingglass")?
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(UIColor(named: "AccentColor")!)

        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = barButton

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String(localized: "Search for countries...")
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        self.searchController = searchController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "Countries")

        collectionView.registerClass(CountryCell.self)
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true

        let dataSource = makeDataSource(for: collectionView)
        self.dataSource = dataSource

        Task(priority: .userInitiated) {
            await interactor.initialize()
        }
    }

    override func refreshCollection() {
        Task(priority: .userInitiated) {
            await interactor.refresh()
        }
    }

    override func setupConstraints() {
        super.setupConstraints()
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @MainActor func updateCollection(with snapshot: NSDiffableDataSourceSnapshot<Section, Country>) {
        dataSource.apply(snapshot)
    }

    @MainActor func updateSnapshot(at row: Country) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([row])
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

    @objc private func searchButtonTapped(_ searchButton: UIBarButtonItem) {
        searchController.searchBar.becomeFirstResponder()
    }

    private func makeDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Country> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Country>(collectionView: collectionView, cellProvider: cellProvider)
        return dataSource
    }

    private func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, country: Country) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(CountryCell.self, for: indexPath)
        let isSelected = interactor.isCountrySelected(country)
        cell.update(using: country)
        if isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        return cell
    }
}

extension CountriesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let row = dataSource.itemIdentifier(for: indexPath) {
            interactor.select(row)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let row = dataSource.itemIdentifier(for: indexPath) {
            interactor.deselect(row)
        }
    }
}

extension CountriesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        searchTask?.cancel()
        let task = Task(priority: .userInitiated) {
            await interactor.filterCountries(by: query)
        }
        self.searchTask = task
    }
}

extension CountriesListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Task(priority: .userInitiated) {
            await interactor.finishSearching()
        }
    }
}
