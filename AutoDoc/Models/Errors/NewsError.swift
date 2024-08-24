//
//  NewsError.swift
//  AutoDoc
//
//  Created by Dolphin on 20.08.2024.
//

import Foundation

enum NewsError: Error {
    case missingData
    case wrongPublishedDate(_ wrongDate: String)
    case wrongDataFormat(error: Error)
}

extension NewsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingData:
            return NSLocalizedString("There is no data", comment: "")
        case .wrongPublishedDate(let wrongDate):
            return NSLocalizedString("There is no valid published date for \(wrongDate)", comment: "")
        case .wrongDataFormat(let error):
            return NSLocalizedString("Could not digest the fetched data. \(error.localizedDescription)", comment: "")
        }
    }
}
