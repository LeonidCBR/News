//
//  NewsFeed.swift
//  AutoDoc
//
//  Created by Dolphin on 20.08.2024.
//

import Foundation

struct NewsFeed: Decodable {
    static let url = URL(string: "https://webapi.autodoc.ru/api/news/1/15")!
    let news: [NewsItem]
    let totalCount: UInt
}
