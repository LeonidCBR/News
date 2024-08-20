//
//  NewsDecoderTests.swift
//  AutoDocTests
//
//  Created by Dolphin on 20.08.2024.
//

import XCTest
@testable import AutoDoc

final class NewsDecoderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNewsDecoder_WhenValidDataWasProvided_ReturnNews() throws {
        let bundle = Bundle(for: NewsDecoderTests.self)
        let jsonURL = bundle.url(forResource: "data",
                                 withExtension: "json")!
        let jsonData = try Data(contentsOf: jsonURL)
        let newsDecoder = try NewsDecoder(with: jsonData)
        XCTAssertEqual(newsDecoder.newsFeed.totalCount, 991)
        let news = newsDecoder.newsFeed.news
        let countNews = 15
        guard news.count == countNews else {
            XCTFail("It has been got \(news.count) news instead of \(countNews)")
            return
        }
        let item = news[3]
        XCTAssertEqual(item.id, 8142)
        XCTAssertEqual(item.title, "Acura подтвердила электрического преемника NSX")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            let bundle = Bundle(for: NewsDecoderTests.self)
            let jsonURL = bundle.url(forResource: "data", withExtension: "json")!
            if let newsData = try? Data(contentsOf: jsonURL),
               let newsDecoder = try? NewsDecoder(with: newsData) {
                _ = newsDecoder.newsFeed
            }
        }
    }

}
