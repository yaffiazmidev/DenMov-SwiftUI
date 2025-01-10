//
//  NetworkRequest.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//

import Foundation

protocol NetworkRequestProvider {
    init(network: NetworkRequest)
}

class NetworkRequest: ObservableObject {
    
    private let client: HTTPClient
    
    init(
        client: HTTPClient = URLSessionHTTPClient(session: .shared)
    ) {
        self.client = client
    }
    
    func request<T: Codable>(from request: URLRequest) async throws -> T {
        
        let (data, response) = try await client.request(from: request)
        
        do {
            let result = try Mapper<T>.map(data, from: response)
            return result
        } catch {
            throw NetworkError.decodingError
        }
    }
}
