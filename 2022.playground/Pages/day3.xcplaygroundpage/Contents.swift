import Foundation

let realInput = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!,
                       encoding: String.Encoding.utf8)
let sampleInput = """
vJrwpWtwJ
jqHRNqRjqzj
PmmdzqP
"""

func getItemPriority(item: Character) -> Int {
    let asciiValue = Int(item.asciiValue ?? 0)
    var itemPriority: Int = 0

    if 65...90 ~= asciiValue {
        itemPriority = asciiValue - 38
    } else if 97...122 ~= asciiValue {
        itemPriority = asciiValue - 96
    }

    return Int(itemPriority)
}

func getCommonItems(compartments: [String]) -> [Character] {
    var matchDict: [Character: Int] = [:]

    for (index, compartment) in compartments.enumerated() {
        for item in compartment {
            if matchDict[item] == nil {
                matchDict[item] = 1
            } else if matchDict[item] ?? 0 > 0 && matchDict[item] == index + 1 {
                matchDict[item]! += 1
            }
        }
    }

    return matchDict
        .filter { dict in
            return dict.value == compartments.count
        }
        .map { $0.key }
}

func getItemValue(for rucksack: String) -> Int {
    let middleOfRuckSack = rucksack.count / 2
    let firstCompartment = rucksack.substring(withRange: 0..<middleOfRuckSack)
    let secondCompartment = rucksack.substring(withRange: middleOfRuckSack..<rucksack.count)

    if let sameItem = getCommonItems(compartments: [firstCompartment, secondCompartment]).first {
        return getItemPriority(item: sameItem)
    }

    return 0
}

func getBadgeValue(for rucksackGroup: [String]) -> Int {
    let firstRucksack = String(rucksackGroup[0])
    let secondRuckSack = String(rucksackGroup[1])
    let thirdRuckSack = String(rucksackGroup[2])

    print("common items", getCommonItems(compartments: [firstRucksack, secondRuckSack, thirdRuckSack]))
    print("#######")
    if let sameItem = getCommonItems(compartments: [firstRucksack, secondRuckSack, thirdRuckSack]).first {
        return getItemPriority(item: sameItem)
    }

    return 0
}

func part1(input: String) -> Int {
    return input
        .split(separator: "\n")
        .map { rucksack in
            return getItemValue(for: String(rucksack))
        }
        .reduce(0, +)
}

func part2(input: String) -> Int {
    let rucksacks = input.split(separator: "\n")
    return stride(from: 0, to: rucksacks.count, by: 3)
        .map { index in
            return rucksacks[index..<index + 3]
                .map { String($0) }
        }
        .map { group in
            return getBadgeValue(for: group)
        }
        .reduce(0, +)
}

print(part2(input: sampleInput))

