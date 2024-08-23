//
//  NewsDecoder.swift
//  AutoDoc
//
//  Created by Dolphin on 20.08.2024.
//

import Foundation

struct NewsDecoder {
    let newsFeed: NewsFeed

    init(with data: Data) throws {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            let newsFeed = try jsonDecoder.decode(NewsFeed.self, from: data)
            self.newsFeed = newsFeed
        } catch {
            throw NewsError.wrongDataFormat(error: error)
        }
    }

}
// TODO: Should I use?
class MyNewsDecoder: JSONDecoder {

}
