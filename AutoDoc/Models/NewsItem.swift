//
//  News.swift
//  AutoDoc
//
//  Created by Dolphin on 20.08.2024.
//

import Foundation

struct NewsItem: Decodable, Hashable {
    let id: UInt
    let title: String
    let description: String
    let publishedDate: Date
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String

    enum CodingKeys: CodingKey {
        case id
        case title
        case description
        case publishedDate
        case fullUrl
        case titleImageUrl
        case categoryType
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UInt.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.fullUrl = try container.decode(String.self, forKey: .fullUrl)
        self.titleImageUrl = try container.decode(String.self, forKey: .titleImageUrl)
        self.categoryType = try container.decode(String.self, forKey: .categoryType)
        let publishedDateString = try container.decode(String.self, forKey: .publishedDate)
        let dateFormatterWithMilliseconds = DateFormatter()
        dateFormatterWithMilliseconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        dateFormatterWithMilliseconds.timeZone = .gmt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = .gmt
        if let publishedDateFull = dateFormatterWithMilliseconds.date(from: publishedDateString) {
            self.publishedDate = publishedDateFull
        } else if let publishedDate = dateFormatter.date(from: publishedDateString) {
            self.publishedDate = publishedDate
        } else {
            throw NewsError.wrongPublishedDate(publishedDateString)
        }
    }

    init(id: UInt,
         title: String,
         description: String,
         publishedDate: Date,
         fullUrl: String,
         titleImageUrl: String,
         categoryType: String) {
        self.id = id
        self.title = title
        self.description = description
        self.publishedDate = publishedDate
        self.fullUrl = fullUrl
        self.titleImageUrl = titleImageUrl
        self.categoryType = categoryType
    }
}
