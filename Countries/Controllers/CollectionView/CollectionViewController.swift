//
//  CollectionViewController.swift
//  Countries
//
//  Created by Alireza Asadi on 12/4/22.
//

import UIKit
import SnapKit

class CollectionViewController: UIViewController {
    var collectionView: UICollectionView!

    override func loadView() {
        super.loadView()

        let refreshControl = UIRefreshControl()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.oneSectionedList(interRowSpacing: 0))
        view.addSubview(collectionView)

        refreshControl.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
        collectionView.refreshControl = refreshControl


        self.collectionView = collectionView
        setupConstraints()
    }

    open func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc open func refreshCollection() {}
}
