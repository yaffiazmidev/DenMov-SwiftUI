//
//  DispatchQueueType.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//


import Foundation

/// Used to easily mock main and background queues in tests
protocol DispatchQueueType {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}