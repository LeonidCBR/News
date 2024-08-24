//
//  SectionHeaderReusableView.swift
//  AutoDoc
//
//  Created by Dolphin on 25.08.2024.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize,
            weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
                self.trailingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 5.0)])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor)
            ])
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            self.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0)
        ])
    }

    required init?(coder: NSCoder) {
        return nil
    }
}
