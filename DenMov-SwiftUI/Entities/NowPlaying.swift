//
//  NowPlaying.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//

import Foundation

struct NowPlaying: Codable {
    let results: [NowPlayingItem]?
    let page: Int?
    let total_pages: Int?
}

struct NowPlayingItem: Codable {
    var id: Int?
    var original_title: String?
    var poster_path: String?
    var genre_ids: [Int]?
    var release_date: String?
}
