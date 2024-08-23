//
//  NewsViewModel.swift
//  AutoDoc
//
//  Created by Dolphin on 21.08.2024.
//

import UIKit
import Combine
/*
struct NewsPublisher: Publisher {
    typealias Output = [NewsItem]
    typealias Failure = Error
    var news: [NewsItem]
    func receive<S>(subscriber: S) where S : Subscriber, any Failure == S.Failure, [NewsItem] == S.Input {
        subscriber.receive(news)
    }
}
*/

@MainActor
final class NewsViewModel {
    private let networkProvider: NetworkProvider
    private let imageProvider: ImageProvider

//    let newsPublisher = Publisher<NewsItem, Error>()
    // TODO: Implement downloading from API
//    @Published private(set) var items: [TodoItem]
    @Published private(set) var news: [NewsItem] = []
//    private(set) var news: [NewsItem] = [
//        NewsItem(id: 8144,
//                 title: "GMC Yukon 2025 с новым дизельным мотором",
//                 description: "Компания GMC представила обновленный Yukon 2025",
//                 publishedDate: Date(),
//                 fullUrl: "https://www.autodoc.ru/avto-novosti/yukon",
//                 titleImageUrl: "https://file.autodoc.ru/news/avto-novosti/351384015_10.jpg",
//                 categoryType: "Автомобильные новости"),
//        NewsItem(id: 8145,
//                 title: "Открытие пункта выдачи заказов в г. Грязи (Липецкая область)",
//                 description: "г. Грязи, ул. Революции 1905 года, д.12/26",
//                 publishedDate: Date(),
//                 fullUrl: "https://www.autodoc.ru/novosti-kompanii/20090",
//                 titleImageUrl: "http://file.autodoc.ru/news/foto_magazinov/pv_gryazi.jpg",
//                 categoryType: "Новости компании")
//    ]
    
    // TODO: Check
    /*
    var newsPublisher: AnyPublisher<NewsItem, Never> {
        return news.publisher.collect(Combine.Publishers.TimeGroupingStrategy<NewsItem>)
//        return news.publisher.eraseToAnyPublisher()
    }
    */

    init(networkProvider: NetworkProvider, imageProvider: ImageProvider) {
        self.networkProvider = networkProvider
        self.imageProvider = imageProvider
    }

//    func fetchNews() async throws {
//        print("DEBUG: \(#function)")
//        let newsData = try await self.networkProvider.downloadData(withUrl: NewsFeed.url)
//        let newsDecoder = try NewsDecoder(with: newsData)
//        news = newsDecoder.newsFeed.news
//    }
    /*
    func getNewsPublisher() -> AnyPublisher<NewsItem, Error> {
        AnyPublisher { subscriber in
            Task {
                do {
                    //                    let result = try await AsyncAwait.doSomethingThrowing()
                    let newsData = try await self.networkProvider.downloadData(withUrl: NewsFeed.url)
                    let newsDecoder = try NewsDecoder(with: newsData)
                    let result = newsDecoder.newsFeed.news
                    subscriber.receive(result)
//                    subscriber.receive(completion: .finished)
                } catch {
                    subscriber.receive(completion: .failure(error))
                }
            }.result
                .publisher
                .eraseToAnyPublisher()
        }
    }
    */
//    func getNewsPublisher() -> AnyPublisher<NewsFeed, Error> {
//        print("DEBUG: \(#function)")
//        return URLSession.shared.dataTaskPublisher(for: NewsFeed.url)
//            .mapError { $0 as Error }
//            .map(\.data)
//            .decode(type: NewsFeed.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
    
    // TODO: implement fetching
    func downloadNews() async throws {
        let newsData = try await self.networkProvider.downloadData(withUrl: NewsFeed.url)
        let newsDecoder = try NewsDecoder(with: newsData)
        news = newsDecoder.newsFeed.news
    }
    
    func getImage(for newsItem: NewsItem) async throws -> UIImage {
        let image = try await imageProvider.fetchImage(withPath: newsItem.titleImageUrl)
        return image
    }
    /*
    static func dealFromDeck(with id: String) -> AnyPublisher<Deal, Error> {
        let url = URL(string: "https://deckofcardsapi.com/api/deck/\(id)/draw/?count=1")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map(\.data)
            .decode(type: Deal.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    */
    /**
     static func doSomethingThrowing() -> AnyPublisher<String, Error> {
         AnyPublisher { subscriber in
             Task {
                 do {
                     let result = try await AsyncAwait.doSomethingThrowing()
                     subscriber.receive(result)
                     subscriber.receive(completion: .finished)
                 } catch {
                     subscriber.receive(completion: .failure(error))
                 }
             }
         }
     }
     */

    // TODO: Check
//    func getImage(for itemId: Int) async throws -> UIImage {
//        print("DEBUG: \(#function)")
//        let image = try await imageProvider.fetchImage(withPath: news[itemId].titleImageUrl)
//        return image
//    }
    
    // It works
//    func getNewsIDs() -> [UInt] {
//        print("DEBUG: \(#function)")
//        return news.map { $0.id }
//    }
//
//    func getNewsItem(with identifier: UInt) -> NewsItem? {
//        print("DEBUG: \(#function)")
//        return news.first(where: { $0.id == identifier })
//    }

}
