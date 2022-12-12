import Foundation

let realInput = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!,
                           encoding: String.Encoding.utf8)

let sampleInput = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""

enum OperandOption {
    case number(_ nb: Int)
    case itself
}

enum Operand {
    case plus(option: OperandOption)
    case multiply(option: OperandOption)

    init?(rawValue: [String]) {
        var option: OperandOption

        if let number = Int(rawValue[2]) {
            option = .number(number)
        } else {
            option = .itself
        }

        switch rawValue[1] {
        case "*":
            self = .multiply(option: option)
        case "+":
            self = .plus(option: option)
        default:
            return nil
        }
    }
}

final class Monkey {
    var items: [Int]
    var operand: Operand
    let worryLevelEnd: Int
    let nextMonkey: Int
    let previousMonkey: Int
    var inspectionCount: Int = 0

    init(monkeyAttributes: [String]) {
        self.items = monkeyAttributes[1]
            .split(separator: ":")[1]
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap(Int.init)

        let operation = monkeyAttributes[2]
            .split(separator: "=")[1]
            .split(separator: " ")
            .map(String.init)

        self.operand = Operand(rawValue: operation) ?? .plus(option: .itself)
        self.worryLevelEnd = Int(monkeyAttributes[3].split(separator: "by ")[1])!
        self.nextMonkey = Int(monkeyAttributes[4].split(separator: "monkey ")[1])!
        self.previousMonkey = Int(monkeyAttributes[5].split(separator: "monkey ")[1])!
    }

    func inspect() {
        self.inspectionCount += 1
    }

    func getWorryLevel(for item: Int) -> Int {
        switch self.operand {
        case .plus(let option):
            switch option {
            case .number(let nb):
                return item + nb
            case .itself:
                return item + item
            }
        case .multiply(let option):
            switch option {
            case .number(let nb):
                return item * nb
            case .itself:
                return item * item
            }
        }
    }

    func getThrowingMonkeyIndex(for worryLevel: Int) -> Int {
        if worryLevel % self.worryLevelEnd == 0 {
            return self.nextMonkey
        } else {
            return self.previousMonkey
        }
    }
}

func createMonkeys(from input: String) -> [Monkey] {
    return input
        .split(separator: "\n\n")
        .map(String.init)
        .map { $0.split(separator: "\n").map { String($0) } }
        .map { Monkey(monkeyAttributes: $0) }
}

func partOne(input: String) -> Int {
    let monkeys = createMonkeys(from: input)
    var i = 0

    while i < 20 {
        for monkey in monkeys {
            while monkey.items.isEmpty != true {
                monkey.inspect()

                let currentItem = monkey.items.removeFirst()
                let worryLevel = monkey.getWorryLevel(for: currentItem)
                let decreasedWorryLevel = worryLevel / 3
                let index = monkey.getThrowingMonkeyIndex(for: decreasedWorryLevel)

                monkeys[index].items.append(decreasedWorryLevel)
            }
        }

        i += 1
    }

    return monkeys
        .map(\.inspectionCount)
        .sorted()
        .suffix(2)
        .reduce(1, *)
}

func partTwo(input: String) -> Int {
    let monkeys = createMonkeys(from: input)
    let commonDenominator = monkeys.map(\.worryLevelEnd).reduce(1, *)
    var i = 0

    while i < 10000 {
        for monkey in monkeys {
            while monkey.items.isEmpty != true {
                monkey.inspect()

                let currentItem = monkey.items.removeFirst()
                var worryLevel = monkey.getWorryLevel(for: currentItem)
                worryLevel %= commonDenominator
                let index = monkey.getThrowingMonkeyIndex(for: worryLevel)

                monkeys[index].items.append(worryLevel)
            }
        }

        i += 1
    }

    return monkeys
        .map(\.inspectionCount)
        .sorted()
        .suffix(2)
        .reduce(1, *)
}

print(partTwo(input: realInput))
