//
//  NewsFeed.swift
//  AutoDoc
//
//  Created by Dolphin on 20.08.2024.
//

import Foundation

struct NewsFeed: Decodable {
    let news: [News]
    let totalCount: UInt
}
