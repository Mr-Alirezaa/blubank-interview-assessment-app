//
//  EmptyCell.swift
//  Countries
//
//  Created by Alireza Asadi on 12/4/22.
//

import UIKit
import SnapKit
import LocalizationBackport

class EmptyCell: UICollectionViewCell {
    private let titleLabel: UILabel = UILabel()
    private let plusButton: UIButton = UIButton()
    private var action: (() -> Void)?

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
        action = nil
    }

    func onAddButtonTapped(_ action: @escaping () -> Void) {
        self.action = action
    }

    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(plusButton)

        setupConstraints()

        titleLabel.text = String(localized: "The list is empty!")
        titleLabel.textColor = .tertiaryLabel
        titleLabel.textAlignment = .center

        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        plusButton.setTitle(String(localized: "Select Countries"), for: .normal)
        plusButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        plusButton.setImage(image, for: .normal)
        plusButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        plusButton.setInsets(
            forContentPadding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8),
            imageTitlePadding: 4
        )
        plusButton.tintColor = UIColor(named: "AccentColor")
        plusButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(44)
            make.leading.greaterThanOrEqualToSuperview().offset(44)
            make.trailing.lessThanOrEqualToSuperview().offset(-44)
        }

        plusButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-44)
            make.leading.greaterThanOrEqualToSuperview().offset(44)
            make.trailing.lessThanOrEqualToSuperview().offset(-44)
        }
    }

    @objc private func buttonTapped(_ button: UIButton) {
        action?()
    }
}
