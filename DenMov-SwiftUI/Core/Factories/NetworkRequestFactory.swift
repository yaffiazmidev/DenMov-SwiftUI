//
//  NetworkRequestFactory.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 11/01/25.
//

import Foundation

class NetworkRequestFactory {
    static func baseRequest() -> NetworkRequest {
        NetworkRequest(client: makeHTTPClient().httpClient)
    }
    
    static func authRequest(
        with config: APIConfig = getConfig(fromPlist: "APIConfig")
    ) -> NetworkRequest {
        NetworkRequest(client: makeHTTPClient(with: config).authHTTPClient)
    }
    
    private static func makeHTTPClient(
        with config: APIConfig = getConfig(fromPlist: "APIConfig")
    ) -> (httpClient: HTTPClient, authHTTPClient: AuthenticatedHTTPClientDecorator) {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10.0
        configuration.timeoutIntervalForResource = 10.0
        
        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: configuration))
        let authHTTPClient = AuthenticatedHTTPClientDecorator(decoratee: httpClient, config: config)
        
        return (httpClient, authHTTPClient)
    }
}
