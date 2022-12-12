import Foundation

let realInput = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!,
                           encoding: String.Encoding.utf8)

let sampleInput = """
"""

func treat(instructions: [[String]]) -> Int {
    var X = 1
    var cycle: Int = 1
    var signals: [Int] = []

    for instruction in instructions {
        if instruction[0] == "noop" {
            if [20, 60, 100, 140, 180, 220].contains(cycle) {
                signals.append(cycle * X)
            }
            cycle += 1
        } else if instruction[0] == "addx", let value = Int(instruction[1]) {
            var i = 0

            while i < 2 {
                if [20, 60, 100, 140, 180, 220].contains(cycle) {
                    signals.append(cycle * X)
                }

                cycle += 1
                i += 1
            }

            X += value
        }
    }

    return signals.reduce(0, +)
}

func treatToPrint(instructions: [[String]]) {
    var X = 1
    var cycle: Int = 1

    for instruction in instructions {
        let spritePosition = X - 1...X + 1

        if instruction[0] == "noop" {
            drawPixel(spritePosition: spritePosition, crt: cycle - 1)

            cycle += 1
        } else if instruction[0] == "addx", let value = Int(instruction[1]) {
            var i = 0

            while i < 2 {
                drawPixel(spritePosition: spritePosition, crt: cycle - 1)

                cycle += 1
                i += 1
            }

            X += value
        }
    }
}

func drawPixel(spritePosition: ClosedRange<Int>, crt: Int) {
    if crt > 0, crt % 40 == 0 {
        print(" ")
    }

    if spritePosition ~= crt % 40 {
        print("#", terminator: "")
    } else {
        print(".", terminator: "")
    }
}

func partOne(input: String) -> Int {
    let instructions = input
        .split(separator: "\n")
        .map(String.init)
        .map { $0.split(separator: " ").map(String.init) }

    return treat(instructions: instructions)
}

func partTwo(input: String) {
    let instructions = input
        .split(separator: "\n")
        .map(String.init)
        .map { $0.split(separator: " ").map(String.init) }

    treatToPrint(instructions: instructions)
}

partTwo(input: realInput)

