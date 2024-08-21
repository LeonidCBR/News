//
//  ViewController.swift
//  AutoDoc
//
//  Created by Dolphin on 20.08.2024.
//

import UIKit

@MainActor
class NewsController: UIViewController {
    let newsViewModel: NewsViewModel
    let newsCellIdentifier = "NewsCellIdentifier"

    let newsCollection: UICollectionView = {
        // TODO: Implement CompositionalLayout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        super.viewDidLoad()
        configureUI()
        fetchNews()
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(newsCollection)
        NSLayoutConstraint.activate([
            newsCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            newsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: newsCollection.trailingAnchor, constant: 8.0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: newsCollection.bottomAnchor)
        ])
        newsCollection.delegate = self
        newsCollection.dataSource = self
        newsCollection.register(NewsItemCell.self, forCellWithReuseIdentifier: newsCellIdentifier)
        // TODO: Delete
        newsCollection.backgroundColor = .cyan
    }

    private func fetchNews() {
        Task { [weak self] in
            do {
                guard let self else { return }
                try await self.newsViewModel.fetchNews()
                self.newsCollection.reloadData()
            } catch {
                print("DEBUG: Error while fetching news: \(error.localizedDescription)")
            }
        }
    }

}

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
