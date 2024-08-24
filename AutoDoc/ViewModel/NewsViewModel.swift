//
//  NewsViewModel.swift
//  AutoDoc
//
//  Created by Dolphin on 21.08.2024.
//

import UIKit
import Combine

@MainActor
final class NewsViewModel {
    // MARK: - Properties
    @Published private(set) var news: [NewsItem] = []
    private let networkProvider: NetworkProvider
    private let cacheImages = NSCache<NSString, UIImage>()

    // MARK: - Life Cycles
    init(networkProvider: NetworkProvider = NetworkProvider()) {
        self.networkProvider = networkProvider
    }

    // MARK: - Functions
    func fetchNews() async throws {
        let newsData = try await self.networkProvider.downloadData(withUrl: NewsFeed.url)
        news = try decodeNewsData(newsData)
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
