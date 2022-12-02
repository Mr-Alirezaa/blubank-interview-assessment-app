//
//  CountriesListViewController.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import UIKit
import SnapKit

enum Section {
    case countries
}

struct Country: Hashable {
    var name: String

    init(name: String) {
        self.name = name
    }
}

class CountriesListViewController: UIViewController {
    var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Country>!

    override func loadView() {
        super.loadView()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.oneSectionedList())
        view.addSubview(collectionView)
        self.collectionView = collectionView

        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"

        collectionView.registerClass(CountryCell.self)
        let dataSource = makeDataSource(for: collectionView)
        self.dataSource = dataSource

        let snapshot = makeSnapshot(countries: [Country(name: "Iran")])
        dataSource.apply(snapshot)
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
