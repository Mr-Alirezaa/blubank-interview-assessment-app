//
//  CountryCell.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import UIKit

class CountryCell: UICollectionViewCell {
    private let titleLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    func update(using country: Country) {
        titleLabel.text = country.name
    }

    private func setupView() {
        contentView.addSubview(titleLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.greaterThanOrEqualToSuperview().offset(16)
        }
    }
}
