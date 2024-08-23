//
//  NewsViewModelTests.swift
//  AutoDocTests
//
//  Created by Dolphin on 20.08.2024.
//

import XCTest
@testable import AutoDoc

final class NewsViewModelTests: XCTestCase {
    var sut: NewsViewModel!

    @MainActor override func setUpWithError() throws {
        sut = NewsViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNewsViewModel_WhenValidDataWasProvided_ReturnNews() async throws {
        let bundle = Bundle(for: NewsViewModelTests.self)
        let jsonURL = bundle.url(forResource: "data",
                                 withExtension: "json")!
        let jsonData = try Data(contentsOf: jsonURL)
        let news = try await sut.decodeNewsData(jsonData)
        let countNews = 15
        guard news.count == countNews else {
            XCTFail("It has been got \(news.count) news instead of \(countNews)")
            return
        }
        let item = news[3]
        XCTAssertEqual(item.id, 8142)
        XCTAssertEqual(item.title, "Acura подтвердила электрического преемника NSX")
        XCTAssertEqual(item.description, "Производство NSX от Acura завершилось в 2022 году")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let testDate = dateFormatter.date(from: "2024-08-19T00:00:00")!
        XCTAssertEqual(item.publishedDate, testDate)
        XCTAssertEqual(item.fullUrl, "https://www.autodoc.ru/avto-novosti/acura_nsx_electro")
        XCTAssertEqual(item.titleImageUrl, "https://file.autodoc.ru/news/avto-novosti/262706931_1.jpg")
        XCTAssertEqual(item.categoryType, "Автомобильные новости")
    }

}
