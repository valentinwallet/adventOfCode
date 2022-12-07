import Foundation

let realInput = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!,
                           encoding: String.Encoding.utf8)

let sampleInput = """
mjqjpqmgbljsphdztnvjfqwrcgsmlb
"""

func allCharacterDifferent(for str: String) -> Bool {
    var dict: [Character: Bool] = [:]

    for character in str {
        if dict[character] == true {
            return false
        }

        dict[character] = true
    }

    return true
}

func partTwo(input: String) -> Int {


    for i in 0..<input.count {
        let rangeUppedBound = min(i + 14, input.count)
        let str = input.substring(withRange: i..<rangeUppedBound)

        if allCharacterDifferent(for: str) {
            return i + 14
        }
    }

    return 0
}

func partOne(input: String) -> Int {
    for i in 0..<input.count {
        let rangeUppedBound = min(i + 4, input.count)
        let str = input.substring(withRange: i..<rangeUppedBound)

        if allCharacterDifferent(for: str) {
            return i + 4
        }
    }

    return 0
}

print(partTwo(input: realInput))
