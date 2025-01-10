//
//  AuthenticatedHTTPClientDecorator.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//


import Foundation

class AuthenticatedHTTPClientDecorator: HTTPClient {
    private let decoratee: HTTPClient
    private let config: APIConfig

    init(decoratee: HTTPClient, config: APIConfig) {
        self.decoratee = decoratee
        self.config = config
    }
    
    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let request = enrich(request, with: config)
        
        do {
            return try await decoratee.request(from: request)
        } catch {
            throw error
        }
    }
}

private extension HTTPClient {
    func enrich(_ request: URLRequest, with config: APIConfig) -> URLRequest {

        guard let requestURL = request.url, var urlComponents = URLComponents(string: requestURL.absoluteString) else { return request }

        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        queryItems.append(.init(name: "api_key", value: config.secret))

        urlComponents.queryItems = queryItems

        guard let authenticatedRequestURL = urlComponents.url else { return request }

        var signedRequest = request
        signedRequest.url = authenticatedRequestURL
        return signedRequest
    }
}
