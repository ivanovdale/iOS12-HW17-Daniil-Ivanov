//
//  PasswordSafeStorage.swift
//  Pr2503
//
//  Created by Daniil (work) on 15.03.2024.
//

import Foundation

final class PasswordSafeStorage {
    private let queue: DispatchQueue
    private var passwordParts: [Int: String] = [:]

    var passwordReader: String {
        var result = ""
        queue.sync {
            let count = passwordParts.count
            for index in 0..<count {
                let value = passwordParts[index]
                if let value {
                    result.append(value)
                }
            }
        }
        return result
    }

    init(queue: DispatchQueue) {
        self.queue = queue
    }

    func writePassword(newValue: String, at index: Int) {
        queue.async(flags: .barrier) {
            self.passwordParts[index] = newValue
        }
    }
}
