//
//  UICompositionalLayout+Extensions.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import UIKit

extension UICollectionViewCompositionalLayout {
    static func oneSectionedList(interRowSpacing: CGFloat = 16) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interRowSpacing

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
