import Foundation

let realInput = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!,
                           encoding: String.Encoding.utf8)

let sampleInput = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""

enum InstructionAction {
    case up
    case left
    case right
    case down
    case unknown
}

final class Instruction {
    let action: InstructionAction
    let steps: Int

    init(instruction: [String]) {
        switch instruction[0] {
        case "D":
            self.action = .down
        case "U":
            self.action = .up
        case "L":
            self.action = .left
        case "R":
            self.action = .right
        default:
            self.action = .unknown
        }

        self.steps = Int(instruction[1]) ?? 0
    }
}

final class Position: Hashable {
    var x: Int
    var y: Int

    var debugDescription: String {
        return "[\(self.x), \(self.y)]"
    }

    init(x: Int = 0, y: Int = 0) {
        self.x = x
        self.y = y
    }

    func copy() -> Position {
        let position = Position(x: self.x, y: self.y)
        return position
    }

    func isSameLine(with position: Position) -> Bool {
        return self.y == position.y
    }

    func isSameColumn(with position: Position) -> Bool {
        return self.x == position.x
    }

    func isSameDiagonal(with position: Position) -> Bool {
        return self.x + 1 == position.x && self.y + 1 == position.y ||
        self.x + 1 == position.x && self.y - 1 == position.y ||
        self.x - 1 == position.x && self.y + 1 == position.y ||
        self.x - 1 == position.x && self.y - 1 == position.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }

    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

final class Rope {
    private let ropeSize: Int

    var knots: [Position] = []
    var tailVisitedPositions = Set<Position>()

    init(ropeSize: Int = 2) {
        self.ropeSize = ropeSize

        for _ in 0..<ropeSize {
            self.knots.append(.init())
        }
    }

    func move(action: InstructionAction, steps: Int) {
        var i = 0

        while i < steps {
            var j = self.knots.count - 1
            self.moveHead(action: action, head: self.knots[j])

            while j > 0 {
                self.moveKnotsIfNecessary(head: self.knots[j],
                                         tail: self.knots[j - 1],
                                         shouldSave: j == 1)
                j -= 1
            }
            i += 1
        }
    }

    private func moveHead(action: InstructionAction, head: Position) {
        switch action {
        case .up:
            head.y += 1
        case .left:
            head.x -= 1
        case .right:
            head.x += 1
        case .down:
            head.y -= 1
        case .unknown:
            print("do nothing")
        }
    }

    private func moveKnotsIfNecessary(head: Position, tail: Position, shouldSave: Bool) {
        if head.isSameLine(with: tail) {
            if abs(head.x - tail.x) == 2 {
                tail.x = tail.x > head.x ? tail.x - 1 : tail.x + 1
            }
        } else if head.isSameColumn(with: tail) {
            if abs(head.y - tail.y) == 2 {
                tail.y = tail.y > head.y ? tail.y - 1 : tail.y + 1
            }
        } else if head.isSameDiagonal(with: tail) {
            return
        } else {
            if head.x > tail.x && head.y > tail.y {
                tail.x += 1
                tail.y += 1
            } else if head.x > tail.x && head.y < tail.y {
                tail.x += 1
                tail.y -= 1
            } else if head.x < tail.x && head.y > tail.y {
                tail.x -= 1
                tail.y += 1
            } else if head.x < tail.x && head.y < tail.y {
                tail.x -= 1
                tail.y -= 1
            }
        }

        if shouldSave {
            self.tailVisitedPositions.insert(tail.copy())
        }
    }
}

func treat(instructions: [Instruction], for rope: Rope) -> Set<Position> {
    for instruction in instructions {
        rope.move(action: instruction.action, steps: instruction.steps)
    }

    return rope.tailVisitedPositions
}

func partOne(input: String) -> Int {
    let instructions = input.split(separator: "\n")
        .map(String.init)
        .map { $0.split(separator: " ") }
        .map { Instruction(instruction: $0.map(String.init)) }

    return treat(instructions: instructions, for: Rope())
        .count
}

func partTwo(input: String) -> Int {
    let instructions = input.split(separator: "\n")
        .map(String.init)
        .map { $0.split(separator: " ") }
        .map { Instruction(instruction: $0.map(String.init)) }

    return treat(instructions: instructions, for: Rope(ropeSize: 10))
        .count
}

print(partTwo(input: sampleInput))
