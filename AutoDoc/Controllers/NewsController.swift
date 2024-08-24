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
class NewsController: UIViewController {
    enum Section {
        case main
    }

    let newsViewModel: NewsViewModel
    var subscription: AnyCancellable?
    
    // TODO: use NewsItem or NewsItem.id???
    var dataSource: UICollectionViewDiffableDataSource<Section, NewsItem>! = nil
//    var dataSource: UICollectionViewDiffableDataSource<Section, UInt>! = nil

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

    lazy var newsCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: mainLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()

    init(with viewModel: NewsViewModel) {
        newsViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        print("DEBUG: \(#function)")
        super.viewDidLoad()
        configureUI()
        configureDataSource()
        createSubscription()
        downloadNews()
    }

    private func configureUI() {
        print("DEBUG: \(#function)")
        view.backgroundColor = .white
        view.addSubview(newsCollection)
        newsCollection.backgroundColor = .cyan
        newsCollection.delegate = self
//        newsCollection.dataSource = self
//        newsCollection.register(NewsItemCell.self, forCellWithReuseIdentifier: newsCellIdentifier)
    }

    func configureDataSource() {
        print("DEBUG: \(#function)")
        let cellRegistration = UICollectionView.CellRegistration<NewsItemCell, NewsItem> { (cell, indexPath, newsItem) in
            // Populate the cell with our item description.
//            cell.label.text = "\(identifier)"
            cell.titleLabel.text = newsItem.title
            // TODO: Set image
//            cell.titleImageView.image = try? await self.newsViewModel.getImage(for: indexPath.item)
            Task { [weak self] in
                cell.titleImageView.image = try await self?.newsViewModel.getImage(for: newsItem)
            }
            cell.contentView.backgroundColor = .systemGray5
//            cell.layer.borderColor = UIColor.black.cgColor
//            cell.layer.borderWidth = 1
        }

//        dataSource = UICollectionViewDiffableDataSource<Section, NewsItem>(collectionView: newsCollection) {
//            (collectionView: UICollectionView, indexPath: IndexPath, identifier: NewsItem) -> UICollectionViewCell? in
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
//        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: newsCollection) { [weak self]
            collectionView, indexPath, newsItem -> UICollectionViewCell? in
//            collectionView, indexPath, identifier -> UICollectionViewCell? in
//            guard let newsItem = self?.newsViewModel.getNewsItem(with: identifier) else { return nil }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: newsItem)
        }
        /**
         // Create the diffable data source and its cell provider.
         recipeListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
             collectionView, indexPath, identifier -> UICollectionViewCell in
             // `identifier` is an instance of `Recipe.ID`. Use it to
             // retrieve the recipe from the backing data store.
             let recipe = dataStore.recipe(with: identifier)!
             return collectionView.dequeueConfiguredReusableCell(using: recipeCellRegistration, for: indexPath, item: recipe)
         }
         */
/*
        // TODO: Get rid of the initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, UInt>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newsViewModel.getNewsIDs())
        dataSource.apply(snapshot, animatingDifferences: false)
        */
    }
    
    func updateData(news: [NewsItem]) {
        print("DEBUG: \(#function)")
//        var snapshot = NSDiffableDataSourceSnapshot<Section, UInt>()
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsItem>()
        snapshot.appendSections([.main])
//        snapshot.appendItems(newsViewModel.getNewsIDs())
        snapshot.appendItems(news)
        dataSource.apply(snapshot, animatingDifferences: false)
//            var snapshot = Snapshot()
//            snapshot.appendSections([.main])
//            snapshot.appendItems(cards)
//            dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func createSubscription() {
        print("DEBUG: \(#function)")
//        let publisher = newsViewModel.getNewsPublisher()
//        subscription = publisher
//            .sink(receiveCompletion: { completion in
//                if case .failure(let err) = completion {
//                    print("DEBUG: Retrieving data failed with error \(err)")
//                }
//            }, receiveValue: { newsFeed in
//                self.updateData(news: newsFeed.news)
//            })

        subscription = newsViewModel.$news
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("DEBUG: Retrieving data failed with error \(err)")
                }
            }, receiveValue: { news in
                self.updateData(news: news)
            })
    }
    /*
    func deal() {
        let publisher = (hand.cards.isEmpty) ? DealerService.dealFromNewDeck() : DealerService.dealFromDeck(with: hand.deck_id!)
        subscription = publisher
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                }
            }, receiveValue: { object in
                self.hand.deck_id = object.deck_id
                self.hand.cards.append(object.cards!.first!)
                self.updateHand(cards: self.hand.cards)
                self.updateTitles(cardsRemaining: object.remaining)
            })
    }
    */

//    private func fetchNews() {
//        print("DEBUG: \(#function) - Implement with combine")
        // TODO: Implement with combine
//        Task { [weak self] in
//            do {
//                guard let self else { return }
//                try await self.newsViewModel.fetchNews()
//                self.newsCollection.reloadData()
//            } catch {
//                print("DEBUG: Error while fetching news: \(error.localizedDescription)")
//            }
//        }
//    }
    private func downloadNews() {
        print("DEBUG: \(#function)")
        Task { [weak self] in
            do {
                try await self?.newsViewModel.fetchNews()
            } catch {
                print("DEBUG: Error while fetching news: \(error.localizedDescription)")
            }
        }
    }

}
/*
extension NewsController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(250)) // 44
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        /**
         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)
         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                          subitems: [item])
         let section = NSCollectionLayoutSection(group: group)
         let layout = UICollectionViewCompositionalLayout(section: section)
         return layout
         */
    }
}
*/
extension NewsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
/*
extension NewsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newsViewModel.news.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: newsCellIdentifier,
                                                            for: indexPath) as? NewsItemCell else {
            return UICollectionViewCell()
        }
        cell.titleImageView.image = nil
        cell.titleLabel.text = newsViewModel.news[indexPath.item].title
        Task { [weak self] in
            guard let self else { return }
            cell.titleImageView.image = try? await self.newsViewModel.getImage(for: indexPath.item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Implement showing news
        let newsItemId = indexPath.item
        print("DEBUG: Selected item \(newsItemId)")
        let newsVC = UIViewController()
        let webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        newsVC.view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: newsVC.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: newsVC.view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: newsVC.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: newsVC.view.bottomAnchor)
        ])
        if let fullUrl = URL(string: newsViewModel.news[newsItemId].fullUrl) {
            webView.loadRequest(URLRequest(url: fullUrl))
            present(newsVC, animated: true)
        } else {
            fatalError("Cannot get url!")
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300.0, height: 250.0)
    }
}
*/
