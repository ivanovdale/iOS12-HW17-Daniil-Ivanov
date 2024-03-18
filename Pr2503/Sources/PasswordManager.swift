//
//  PasswordManager.swift
//  Pr2503
//
//  Created by Daniil (work) on 14.03.2024.
//

import Foundation

final class PasswordManager {
    private var possiblePasswordTimer: Timer?

    func startRandomPasswordSelection(passwordToUnlock: String, inProccessHandler: @escaping StringClosure) {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            let randomPassword = self.generateRandomPassword(length: passwordToUnlock.count)
            inProccessHandler(randomPassword)
        })
        self.possiblePasswordTimer = timer

        RunLoop.current.add(timer, forMode: .common)
        RunLoop.current.run()
    }

    func stopRandomPasswordSelection() {
        possiblePasswordTimer?.invalidate()
        possiblePasswordTimer = nil
    }

    private func generateRandomPassword(length: Int, logPrint: Bool = false) -> String {
        let passwordCharacters = String().printable
        let randomPassword = String((0..<length).compactMap{ _ in passwordCharacters.randomElement() })
        if logPrint {
            print("Generated password: \(randomPassword)")
        }

        return randomPassword
    }
}
