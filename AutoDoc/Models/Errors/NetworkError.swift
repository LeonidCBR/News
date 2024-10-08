//
//  NetworkError.swift
//  AutoDoc
//
//  Created by Dolphin on 20.08.2024.
//

import Foundation

enum NetworkError: Error {
    case noResponse
    case unauthorized
    case unhandledError(_ statusCode: Int)
    case unexpectedData
    case unexpectedURL
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noResponse:
            return NSLocalizedString("There is no response.",
                                     comment: "")
        case .unauthorized:
            return NSLocalizedString("Wrong credentials.",
                                     comment: "")
        case .unhandledError(let status):
            return NSLocalizedString("Unhandled error with code: \(status)",
                                     comment: "")
        case .unexpectedData:
            return NSLocalizedString("Wrong or incorrect data.",
                                     comment: "")
        case .unexpectedURL:
            return NSLocalizedString("Wrong URL.",
                                     comment: "")
        }
    }
}
