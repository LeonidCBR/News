//
//  CollectionViewCell.swift
//  AutoDoc
//
//  Created by Dolphin on 21.08.2024.
//

import UIKit

class NewsItemCell: UICollectionViewCell {
    // MARK: - Properties
//    static let reuseIdentifier = "NewsCellReuseIdentifier"
    static var reuseIdentifier: String {
      return String(describing: NewsItemCell.self)
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        return imageView
    }()

    let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5.0
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7.0
        view.layer.masksToBounds = false
        return view
    }()

    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Functions
    private func configureUI() {
        contentView.addSubview(shadowView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        let padding: CGFloat = 8.0
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: padding),
            shadowView.topAnchor.constraint(equalTo: imageView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 62.0)
        ])
    }
}
