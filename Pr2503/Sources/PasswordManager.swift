//
//  PasswordManager.swift
//  Pr2503
//
//  Created by Daniil (work) on 14.03.2024.
//

import Foundation

final class PasswordManager {
    static func generateRandomPassword(length: Int) -> String {
        let passwordCharacters = String().printable
        let randomPassword = String((0..<length).compactMap{ _ in passwordCharacters.randomElement() })
        print("Generated password: \(randomPassword)")

        return randomPassword
    }
}
