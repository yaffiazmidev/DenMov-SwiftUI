//
//  APIConfig.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//


import Foundation

struct APIConfig: Decodable {
    let secret: String
    
    init(secret: String) {
        self.secret = secret
    }
}
