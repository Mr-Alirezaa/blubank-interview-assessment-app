//
//  CountryCell.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import UIKit
import SnapKit
import CountriesCore

class CountryCell: UICollectionViewCell {
    private let titleLabel: UILabel = UILabel()
    private let dividerView: UIView = UIView()
    private let checkImageView: UIImageView = UIImageView()

    override var isSelected: Bool {
        didSet {
            updateSelectionAppearance(isSelected: isSelected)
        }
    }

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
        isSelected = false
    }

    func update(using country: Country) {
        titleLabel.text = "\(country.flagEmoji) \(country.name.common)"
    }

    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(checkImageView)

        setupConstraints()

        dividerView.backgroundColor = .systemGray4
        checkImageView.contentMode = .scaleAspectFit
        checkImageView.tintColor = UIColor(named: "AccentColor")

        updateSelectionAppearance(isSelected: isSelected)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
        }

        dividerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(0.5)
        }

        checkImageView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(10)
            make.centerY.equalTo(titleLabel)
            make.top.lessThanOrEqualToSuperview().offset(-10)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(16)
        }
    }

    private func updateSelectionAppearance(isSelected: Bool) {
        checkImageView.image = isSelected ? UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate) : nil
    }
}
