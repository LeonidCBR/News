//
//  CollectionViewCell.swift
//  AutoDoc
//
//  Created by Dolphin on 21.08.2024.
//

import UIKit

class NewsItemCell: UICollectionViewCell {
    static let reuseIdentifier = "news-cell-reuse-identifier"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    private func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleImageView)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8.0),
            titleImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            titleImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 8.0)
            // TODO: Check
//            titleImageView.widthAnchor
//            titleImageView.heightAnchor
        ])
        // TODO: Delete
        backgroundColor = .lightGray
    }
}

/**
 class TextCell: UICollectionViewCell {
     let label = UILabel()
     static let reuseIdentifier = "text-cell-reuse-identifier"

     override init(frame: CGRect) {
         super.init(frame: frame)
         configure()
     }
     required init?(coder: NSCoder) {
         fatalError("not implemnted")
     }

 }

 extension TextCell {
     func configure() {
         label.translatesAutoresizingMaskIntoConstraints = false
         label.adjustsFontForContentSizeCategory = true
         contentView.addSubview(label)
         label.font = UIFont.preferredFont(forTextStyle: .caption1)
         let inset = CGFloat(10)
         NSLayoutConstraint.activate([
             label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
             label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
             label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
             label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
             ])
     }
 }
 */
