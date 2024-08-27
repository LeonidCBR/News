//
//  NewsViewModel.swift
//  AutoDoc
//
//  Created by Dolphin on 21.08.2024.
//

import UIKit
import Combine

@MainActor
final class NewsViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var news: [NewsItem] = []
    private var isLoading: Bool = false
    private var canLoadMorePages = true
    private var currentPage = 1
    private let countItemsPerPage = 15
    private let urlString = "https://webapi.autodoc.ru/api/news/"
    private let networkProvider: NetworkProvider
    private let cacheImages = NSCache<NSString, UIImage>()

    // MARK: - Life Cycles
    init(networkProvider: NetworkProvider = NetworkProvider()) {
        self.networkProvider = networkProvider
    }

    // MARK: - Functions
    func loadMoreNews() async throws {
        guard !isLoading && canLoadMorePages else { return }
        isLoading = true
        do {
            let newsUrl = URL(string: urlString + "\(currentPage)/\(countItemsPerPage)")!
            let newsData = try await self.networkProvider.downloadData(withUrl: newsUrl)
            let newItems = try decodeNewsData(newsData)
            news.append(contentsOf: newItems)
            currentPage += 1
            canLoadMorePages = newItems.count == countItemsPerPage
            isLoading = false
        } catch {
            isLoading = false
            throw error
        }
    }

    func decodeNewsData(_ newsData: Data) throws -> [NewsItem] {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            let newsFeed = try jsonDecoder.decode(NewsFeed.self, from: newsData)
            return newsFeed.news
        } catch {
            throw NewsError.wrongDataFormat(error: error)
        }
    }

    func getImage(for newsItem: NewsItem) async throws -> UIImage {
        // Check if image exists in cache
        let imagePath = newsItem.titleImageUrl
        if let cachedImage = cacheImages.object(forKey: imagePath as NSString) {
            return cachedImage
        }
        // Check image path
        guard let imageUrl = URL(string: imagePath) else {
            throw NetworkError.unexpectedURL
        }
        // Download image
        let imageData = try await networkProvider.downloadData(withUrl: imageUrl)
        if let image = UIImage(data: imageData) {
            // Add image to cache
            cacheImages.setObject(image, forKey: imagePath as NSString)
            return image
        } else {
            throw NetworkError.unexpectedData
        }
    }

}
