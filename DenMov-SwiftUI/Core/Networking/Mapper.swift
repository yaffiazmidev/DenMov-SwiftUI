//
//  Mapper.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//

import Foundation

final class Mapper<T: Codable> {
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> T {
        
        guard (200...299).contains(response.statusCode) else {
            switch response.statusCode {
            case 401: // Unauthorized
                throw NetworkError.unauthorized
            case 403: // Forbidden
                throw NetworkError.forbidden
            case 404: // Not Found
                throw NetworkError.notFound
            case 400...499: // Other client errors
                throw NetworkError.serverError(statusCode: response.statusCode)
            case 500...599: // Server errors
                throw NetworkError.serverError(statusCode: response.statusCode)
            default:
                throw NetworkError.unknownError
            }
        }
        
        guard let response = try? JSONDecoder().decode(T.self, from: data) else {
            print("❌ Decoding Error:", NetworkError.decodingError.errorDescription ?? "")
            throw NetworkError.decodingError
        }
        
        return response
    }
}
