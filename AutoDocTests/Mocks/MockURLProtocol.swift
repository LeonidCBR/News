//
//  MockURLProtocol.swift
//  AutoDocTests
//
//  Created by Dolphin on 20.08.2024.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var stubResponse: URLResponse?
    static var stubData: Data?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            self.client?.urlProtocol(self,
                                     didReceive: MockURLProtocol.stubResponse ?? URLResponse(),
                                     cacheStoragePolicy: .allowed)
            self.client?.urlProtocol(self,
                                     didLoad: MockURLProtocol.stubData ?? Data())
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}
