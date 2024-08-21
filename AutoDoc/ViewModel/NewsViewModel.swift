//
//  NewsViewModel.swift
//  AutoDoc
//
//  Created by Dolphin on 21.08.2024.
//

import UIKit

final class NewsViewModel {
    private let networkProvider: NetworkProvider
    private let imageProvider: ImageProvider
    private(set) var news: [NewsItem] = []

    init(networkProvider: NetworkProvider, imageProvider: ImageProvider) {
        self.networkProvider = networkProvider
        self.imageProvider = imageProvider
    }

    func fetchNews() async throws {
        let newsData = try await self.networkProvider.downloadData(withUrl: NewsFeed.url)
        let newsDecoder = try NewsDecoder(with: newsData)
        news = newsDecoder.newsFeed.news
    }
    
    func getImage(for itemId: Int) async throws -> UIImage {
        let image = try await imageProvider.fetchImage(withPath: news[itemId].titleImageUrl)
        return image
    }
}
