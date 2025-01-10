//
//  UUID+initial.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//


import Foundation

struct ID<T>: Equatable, Hashable, Codable {
    private var value = UUID()
}
