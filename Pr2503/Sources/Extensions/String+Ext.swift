//
//  String+Ext.swift
//  Pr2503
//
//  Created by Daniil (work) on 14.03.2024.
//

import Foundation

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }

    func split(every: Int) -> [String] {
        var result = [String]()

        for i in stride(from: 0, to: self.count, by: every) {
            let startIndex = self.index(self.startIndex, offsetBy: i)
            let endIndex = self.index(startIndex, offsetBy: every, limitedBy: self.endIndex) ?? self.endIndex
            result.append(String(self[startIndex..<endIndex]))
        }

        return result
    }
}
