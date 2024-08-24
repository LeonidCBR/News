//
//  ViewController.swift
//  AutoDoc
//
//  Created by Dolphin on 20.08.2024.
//

import UIKit
import Combine
import SafariServices

@MainActor
class NewsController: UICollectionViewController {
    enum Section {
        case main
    }
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, NewsItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NewsItem>

    // MARK: - Properties
    let newsViewModel: NewsViewModel
    var subscription: AnyCancellable?
    private lazy var dataSource: DataSource = makeDataSource()

    var mainLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    // MARK: - Life Cycles
    init(with viewModel: NewsViewModel) {
        newsViewModel = viewModel
        super.init(collectionViewLayout: NewsController.makeLayout())
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        createSubscription()
        downloadNews()
    }

    // MARK: - Functions
    private func configureUI() {
        title = "Новости"
        view.backgroundColor = .white
    }

    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<NewsItemCell, NewsItem> { (cell, _, newsItem) in
            cell.titleLabel.text = newsItem.title
            Task { [weak self, weak cell] in
                cell?.imageView.image = try await self?.newsViewModel.getImage(for: newsItem)
            }
        }
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, newsItem -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: newsItem)
        }
        return dataSource
    }

    static func makeLayout() -> UICollectionViewLayout {
//        collectionView.register(
//            SectionHeaderReusableView.self,
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
//        )
        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
            )
            let itemCount = isPhone ? 1 : 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10
            // Supplementary header view setup
//            let headerFooterSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .estimated(20)
//            )
//            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//                layoutSize: headerFooterSize,
//                elementKind: UICollectionView.elementKindSectionHeader,
//                alignment: .top
//            )
//            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
        return compositionalLayout
    }

    private func updateData(news: [NewsItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(news)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func createSubscription() {
        subscription = newsViewModel.$news
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("DEBUG: Retrieving data failed with error \(err)")
                }
            }, receiveValue: { news in
                self.updateData(news: news)
            })
    }

    private func downloadNews() {
        Task { [weak self] in
            do {
                try await self?.newsViewModel.fetchNews()
            } catch {
                // TODO: Show Alert
                print("DEBUG: Error while fetching news: \(error.localizedDescription)")
            }
        }
    }

}

// MARK: - UICollectionViewDataSource Implementation
extension NewsController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            guard let self = self else { return }
            cell.alpha = 1.0
            guard let newsItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
            guard let newsUrl = URL(string: newsItem.fullUrl) else { return }
            let newsVC = SFSafariViewController(url: newsUrl)
            self.present(newsVC, animated: true)
        })
    }
}
