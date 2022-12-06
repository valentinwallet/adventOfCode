import Foundation

let realInput = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!,
                           encoding: String.Encoding.utf8)

let sampleInput = """
24-66,23-25
3-3,2-80
14-80,13-20
39-78,40-40
36-90,89-90
51-94,50-50
10-72,10-98
"""

// 24-66, 23-25 OUI
// 3-3, 2-80 OUI
// 14-80, 13-20 OUI
// 39-78, 40-40 OUI
// 36-90, 89-90 OUI
// 51-94, 50-50 NON
// 10-72, 10-98 OUI

// should be 6


func isOverlapping(elf1: String, elf2: String) -> Bool {
    let elfSection1 = elf1.split(separator: "-")
    let elfSection2 = elf2.split(separator: "-")

    guard let startFirstElf = Int(elfSection1[0]),
            let endFirstElf = Int(elfSection1[1]),
            let startSecondElf = Int(elfSection2[0]),
          let endSecondElf = Int(elfSection2[1]) else { return false }

    let firstRange = startFirstElf...endFirstElf
    let secondRange = startSecondElf...endSecondElf

    return firstRange.overlaps(secondRange)
}

func isContained(elf1: String, elf2: String) -> Bool {
    let elfSection1 = elf1.split(separator: "-")
    let elfSection2 = elf2.split(separator: "-")

    guard let startFirstElf = Int(elfSection1[0]),
            let endFirstElf = Int(elfSection1[1]),
            let startSecondElf = Int(elfSection2[0]),
          let endSecondElf = Int(elfSection2[1]) else { return false }

    if startSecondElf >= startFirstElf &&
       endSecondElf <= endFirstElf {
        return true
    }

    if startFirstElf >= startSecondElf &&
       endFirstElf <= endSecondElf {
        return true
    }

    return false
}

func partOne(input: String) -> Int {
    return input
        .split(separator: "\n")
        .map { elves in
            let elvesSections = elves
                .split(separator: ",")
            return isContained(elf1: String(elvesSections[0]), elf2: String(elvesSections[1]))
        }
        .map { isContained in
            return isContained ? 1 : 0
        }
        .reduce(0, +)
}

func partTwo(input: String) -> Int {
    return input
        .split(separator: "\n")
        .map { elves in
            let elvesSections = elves
                .split(separator: ",")
            return isOverlapping(elf1: String(elvesSections[0]), elf2: String(elvesSections[1]))
        }
        .map { isContained in
            return isContained ? 1 : 0
        }
        .reduce(0, +)
}

print(partTwo(input: realInput))


