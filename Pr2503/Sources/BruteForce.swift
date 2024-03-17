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

        }
    }

    static func execute(passwordToUnlock: String, completionHandler: @escaping StringClosure) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        let splittedPassword = passwordToUnlock.split(every: 2)
        let numberOfIterations = splittedPassword.count

        let workItem = DispatchWorkItem {
            print("Start bruteforcing...")
            DispatchQueue.concurrentPerform(iterations: numberOfIterations) { index in
                var password = ""
                let passwordToUnlock = splittedPassword[index]
                while password != passwordToUnlock {
                    password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                }
                print("End bruteforcing... \(index) Password part: \(password) on  \(Thread.current)")

                writePassword(newValue: password, at: index)
            }
        }

        workItem.notify(queue: queue) {
            print("Password found: \(passwordReader)")
            completionHandler(passwordReader)
        }

        queue.async(execute: workItem)
    }

    private static func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    private static func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }

    private static func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
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
