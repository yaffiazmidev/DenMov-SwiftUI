//
//  URLSessionHTTPClient.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//


import Foundation

final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation : Error {}
    
    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        
        if Task.isCancelled {
            try Task.checkCancellation()
        }
        
        let task = Task {
            do {
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw UnexpectedValuesRepresentation()
                }
                
                // Log HTTP Status Code and URL Request
                print("""
                ==================================================================================================================
                | HTTP Status Code = \(httpResponse.statusCode)
                | URL Request      = \(request.url?.absoluteString ?? "")
                """)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                   let jsonDataPretty = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let jsonString = String(data: jsonDataPretty, encoding: .utf8) {
                    print("| Response JSON:")
                    print(jsonString)  // This will print the formatted JSON in the debug console
                } else {
                    print("Failed to format JSON")
                }
                
                
                return (data, httpResponse)
                
            } catch {
                throw error
            }
        }
        
        return try await withTaskCancellationHandler {
            try await task.value
        } onCancel: {
            task.cancel()
        }
    }
}
