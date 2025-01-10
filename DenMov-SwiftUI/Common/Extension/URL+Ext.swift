//
//  URL+Ext.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//

import Foundation

extension URL {
    static var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }
    
    static var imageBaseURL: URL {
        URL(string: "https://image.tmdb.org/t/p/w500")!
    }
}
