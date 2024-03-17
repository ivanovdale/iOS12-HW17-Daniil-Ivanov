//
//  BruteForce.swift
//  Pr2503
//
//  Created by Daniil (work) on 14.03.2024.
//

import Foundation

typealias StringClosure = (String) -> ()

final class BruteForce {
    private let bruteForceQueue = DispatchQueue(
        label: "BruteForceQueue",
        qos: .userInteractive,
        attributes: .concurrent
    )

    private let passwordStorage: PasswordSafeStorage


    private var workItem: DispatchWorkItem?

    init() {
        self.passwordStorage = PasswordSafeStorage(queue: bruteForceQueue)
    }

    func execute(
        passwordToUnlock: String,
        completionHandler: @escaping StringClosure
    ) {
        setupWorkItem(passwordToUnlock: passwordToUnlock)

        workItem?.notify(queue: bruteForceQueue) {
            guard !(self.workItem?.isCancelled ?? true) else { return }

            let password = self.passwordStorage.passwordReader
            print("Password found: \(password)")
            completionHandler(password)
        }

        if let workItem {
            bruteForceQueue.async(execute: workItem)
        }
    }

    private func setupWorkItem(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }

        let splittedPassword = passwordToUnlock.split(every: 2)
        let iterations = splittedPassword.count

        workItem = DispatchWorkItem {
            print("Start bruteforcing...")
            DispatchQueue.concurrentPerform(iterations: iterations) { iteration in
                self.performBruteForce(
                    allowedCharacters: allowedCharacters,
                    splittedPassword: splittedPassword,
                    iteration: iteration
                )
            }
        }
    }

    private func performBruteForce(
        allowedCharacters: [String],
        splittedPassword: [String],
        iteration: Int
    ) {
        var password = ""
        let passwordToUnlock = splittedPassword[iteration]
        while password != passwordToUnlock {
            password = self.generateBruteForce(password, fromArray: allowedCharacters)
            
            usleep(2000)
        }

        print("End bruteforcing... \(iteration) Password part: \(password) on  \(Thread.current)")

        self.passwordStorage.writePassword(newValue: password, at: iteration)
    }

    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }

    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
}
