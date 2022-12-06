import Foundation
let realInput = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!,
                           encoding: String.Encoding.utf8)

let sampleInput = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""

struct Stack<Element> {
    var items = [Element]()

    func top() -> Element? {
        return items.last
    }

    mutating func push(_ item: Element) {
        items.append(item)

    }

    mutating func pop() -> Element {
        return items.removeLast()
    }
}

func createStacks(for crates: [String]) -> [Stack<Character>] {
    var cratesStacks: [Stack<Character>] = []
    let cratesIndexes = crates.last ?? ""

    for character in cratesIndexes {
        if character.isNumber {
            cratesStacks.append(.init())
        }
    }

    var i = crates.count - 1
    while i >= 0 {
        let currentCrate = crates[i]

        for (index, character) in currentCrate.enumerated() {
            if character.isLetter && character.isUppercase {
                if let crateIndex = Int(cratesIndexes[index]) {
                    cratesStacks[crateIndex - 1].push(character)
                }
            }
        }

        i -= 1
    }

    return cratesStacks
}

func apply(instructions: [String], onStacks stacks: [Stack<Character>]) -> [Stack<Character>] {
    var finalStacks = stacks

    for instruction in instructions {
        let moves = instruction
            .split(separator: " ")
            .compactMap { Int($0) }

        let numberOfCrates = moves[0]
        let fromStack = moves[1] - 1
        let toStack = moves[2] - 1

        for _ in 0..<numberOfCrates {
            let crate = finalStacks[fromStack].pop()
            finalStacks[toStack].push(crate)
        }
    }

    return finalStacks
}

func apply2(instructions: [String], onStacks stacks: [Stack<Character>]) -> [Stack<Character>] {
    var finalStacks = stacks

    for instruction in instructions {
        let moves = instruction
            .split(separator: " ")
            .compactMap { Int($0) }

        let numberOfCrates = moves[0]
        let fromStack = moves[1] - 1
        let toStack = moves[2] - 1
        var cratesToAdd: [Character] = []

        for i in 0..<numberOfCrates {
            print(i)
            let crate = finalStacks[fromStack].pop()
            cratesToAdd.append(crate)
        }

        print(cratesToAdd)

        var i = cratesToAdd.count - 1

        while i >= 0 {
            finalStacks[toStack].push(cratesToAdd[i])
            i -= 1
        }
    }

    return finalStacks
}

func partOne(input: String) -> String {
    let parsedInput = input
        .split(separator: "\n\n")
        .map { $0.split(separator: "\n") }

    let crates = parsedInput[0]
        .map { String($0) }
    let instructions = parsedInput[1]
        .map { String($0) }

    let cratesStack = createStacks(for: crates)
    let stackAfterInstructions = apply(instructions: instructions, onStacks: cratesStack)

    return stackAfterInstructions
        .compactMap { $0.top() }
        .reduce("") { $0 + String($1) }
}

func partTwo(input: String) -> String {
    let parsedInput = input
        .split(separator: "\n\n")
        .map { $0.split(separator: "\n") }

    let crates = parsedInput[0]
        .map { String($0) }
    let instructions = parsedInput[1]
        .map { String($0) }

    let cratesStack = createStacks(for: crates)
    let stackAfterInstructions = apply2(instructions: instructions, onStacks: cratesStack)

    return stackAfterInstructions
        .compactMap { $0.top() }
        .reduce("") { $0 + String($1) }
}

print(partTwo(input: realInput))
