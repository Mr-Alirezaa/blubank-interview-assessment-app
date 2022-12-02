//
//  UICollectionView+registerNib.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import UIKit

extension UICollectionView {
    func registerNib<C: UICollectionViewCell>(for type: C.Type) {
        let name = String(describing: type)
        register(UINib(nibName: name, bundle: .main), forCellWithReuseIdentifier: name)
    }

    func registerClass<C: UICollectionViewCell>(_ type: C.Type) {
        let name = String(describing: type)
        register(type, forCellWithReuseIdentifier: name)
    }

    func registerSupplementaryNib<C: UICollectionReusableView>(for type: C.Type, forSupplementaryViewOfKind elementKind: String) {
        let name = String(describing: type)
        register(UINib(nibName: name, bundle: .main), forSupplementaryViewOfKind: elementKind, withReuseIdentifier: name)
    }

    func registerSupplementaryClass<C: UICollectionReusableView>(_ type: C.Type, forSupplementaryViewOfKind elementKind: String) {
        let name = String(describing: type)
        register(type, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: name)
    }

    func dequeueReusableCell<C: UICollectionViewCell>(_ type: C.Type, for indexPath: IndexPath) -> C {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? C else {
            fatalError(
                """
                Couldn'd find a cell with identifier \"\(String(describing: type))\".
                Check the identifier in the nib file related to \(String(describing: type)).
                """
            )
        }

        return cell
    }

    func dequeueReusableSupplementaryView<C: UICollectionReusableView>(ofKind elementKind: String, type: C.Type, for indexPath: IndexPath) -> C {
        guard let sView = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: String(describing: type), for: indexPath) as? C else {
            fatalError(
                """
                Couldn'd find a supplementary view with identifier \"\(String(describing: type))\".
                Check the identifier in the nib file related to \(String(describing: type)).
                """
            )
        }

        return sView
    }
}
