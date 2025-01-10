//
//  MovieEndpoint.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//

import Foundation

enum MovieEndpoint {
    case nowPlaying(_ request: PagedNowPlayingRequest)
    case credits(movieId: Int)
    case movie(id: Int)
    case popular(_ request: PagedRequest)
    case search(_ request: PagedSearchRequest)
    
    func url(baseURL: URL = .baseURL) -> URLRequest {
        switch self {
        case .nowPlaying(let request):
            return .url(baseURL)
                .path("/movie/now_playing")
                .queries([
                    .init(name: "language", value: request.language),
                    .init(name: "page", value: "\(request.page)")
                ])
                .build()
            
        case .credits(let movieId):
            return .url(baseURL)
                .path("/movie/\(movieId)/credits")
                .queries([
                    .init(name: "language", value: "en-US")
                ])
                .build()
            
        case .movie(let id):
            return .url(baseURL)
                .path("/movie/\(id)")
                .queries([
                    .init(name: "language", value: "en-US")
                ])
                .build()
            
        case .popular(let request):
            return .url(baseURL)
                .path("/movie/popular")
                .queries([
                    .init(name: "language", value: request.language),
                    .init(name: "page", value: "\(request.page)")
                ])
                .build()
            
        case .search(let request):
            return .url(baseURL)
                .path("/search/movie")
                .queries([
                    .init(name: "query", value: request.query),
                    .init(name: "language", value: request.language),
                    .init(name: "page", value: "\(request.page)")
                ])
                .build()
        }
    }
}

struct PagedRequest {
    let page: Int
    let language: String
    
    init(page: Int, language: String = "en-US") {
        self.page = page
        self.language = language
    }
}

struct PagedNowPlayingRequest {
    let page: Int
    let language: String
    
    init(page: Int, language: String = "en-US") {
        self.page = page
        self.language = language
    }
}

struct PagedSearchRequest {
    let query: String
    let page: Int
    let language: String
    
    init(query: String, page: Int = 1, language: String = "en-US") {
        self.query = query
        self.page = page
        self.language = language
    }
}
