//
//  URLRequest+Builder.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//


import Foundation

extension URLRequest {
    
    struct Builder {
        
        enum HTTPMethod: String {
            case GET
            case POST
            case PUT
            case PATCH
            case DELETE
            case UPDATE
        }
        
        private var components = URLComponents()
        private var method: HTTPMethod = .GET
        private var headers: [String: String] = [:]
        private var body: Data?
        
        private init() {}
        
        static func url(_ url: URL) -> Builder {
            var builder = Builder()
            builder.components.scheme = url.scheme
            builder.components.host = url.host
            builder.components.path = url.path
            return builder
        }
        
        func method(_ method: HTTPMethod) -> Builder {
            var builder = self
            builder.method = method
            return builder
        }
        
        func path(_ path: String) -> Builder {
            var builder = self
            builder.components.path += path
            return builder
        }
        
        func headers(key: String, value: String) -> Builder {
            var builder = self
            builder.headers[key] = value
            return builder
        }
        
        func body(data: Encodable) -> Builder {
            var builder = self
            builder.body = try? JSONEncoder().encode(data)
            return builder
        }
        
        func queries(_ queries: [URLQueryItem]) -> Builder {
            var builder = self
            builder.components.queryItems = queries.compactMap { $0 }
            return builder
        }
        
        func queriesEncodable(_ queries: Encodable?) -> Builder {
            var builder = self
            
            guard let queryParameters = queries?.toDictionary() else {
                builder.components.queryItems = nil
                return builder
            }
            
            var urlQueryItems = [URLQueryItem]()
            urlQueryItems = queryParameters.compactMap({ URLQueryItem(name: $0.key, value: "\($0.value)") })
            builder.components.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
            return builder
        }
        
        func build() -> URLRequest {
            guard let url = components.url else {
                fatalError("URL is not set")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            request.httpBody = body
            
            return request
        }
    }
    
    static func url(_ url: URL) -> Builder {
        return Builder.url(url)
    }
}

extension Encodable {
    func toDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let josnData = try JSONSerialization.jsonObject(with: data)
            return josnData as? [String : Any]
        } catch {
            return nil
        }
    }
}
