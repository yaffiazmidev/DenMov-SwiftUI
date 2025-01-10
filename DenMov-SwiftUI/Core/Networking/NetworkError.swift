//
//  NetworkError.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
    case connectivity
    case invalidData
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .unauthorized:
            return "Unauthorized access. Please check your credentials."
        case .forbidden:
            return "Access forbidden. You don't have permission."
        case .notFound:
            return "The requested resource could not be found."
        case .serverError(let statusCode):
            return "Server error occurred. Status code: \(statusCode)"
        case .decodingError:
            return "Failed to decode response data."
        case .unknownError:
            return "An unknown error occurred."
        case .connectivity:
            return "Tidak ada koneksi internet"
        case .invalidData: 
            return "Gagal memuat data"
        }
    }
}
