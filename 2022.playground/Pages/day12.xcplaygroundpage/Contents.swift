import Foundation

let input = """
"""

final class Node {
    var x: Int
    var y: Int
    var distance: Int

    init(x: Int, y: Int, distance: Int) {
        self.x = x
        self.y = y
        self.distance = distance
    }
}

func findPositions(of character: Character, in matrix: [[Character]]) -> [(x: Int, y: Int)] {
    var y = 0
    var startPositions: [(x: Int, y: Int)] = []

    while y < matrix.count {
        var x = 0

        while x < matrix[y].count {
            if matrix[y][x] == character {
                startPositions.append((x: x, y: y))
            }
            x += 1
        }

        y += 1
    }

    return startPositions
}


func isPathUsable(from startCharacter: Character, to destinationCharacter: Character) -> Bool {
    guard destinationCharacter != ".",
          let startAsciiValue = startCharacter.asciiValue,
          let destinationAsciiValue = destinationCharacter.asciiValue else {
        return false
    }

    if destinationAsciiValue < startAsciiValue {
        if startCharacter == "z" && destinationCharacter == "E" {
            return true
        } else if startCharacter != "z" && destinationCharacter == "E" {
            return false
        }

        return true
    }

    return startAsciiValue == destinationAsciiValue || startAsciiValue + 1 == destinationAsciiValue
}

func getNeighbours(from node: Node, in matrix: [[Character]]) -> [Node] {
    let rowsCount = matrix.count
    let columnsCount = matrix.first!.count
    let currentCharacter = matrix[node.y][node.x]
    var neighbours: [Node] = []

    if node.x - 1 >= 0,
       isPathUsable(from: currentCharacter, to: matrix[node.y][node.x - 1]) {
        neighbours.append(.init(x: node.x - 1, y: node.y, distance: node.distance + 1))
    }

    if node.x + 1 < columnsCount,
       isPathUsable(from: currentCharacter, to: matrix[node.y][node.x + 1]) {
        neighbours.append(.init(x: node.x + 1, y: node.y, distance: node.distance + 1))
    }

    if node.y - 1 >= 0,
       isPathUsable(from: currentCharacter, to: matrix[node.y - 1][node.x]) {
        neighbours.append(.init(x: node.x, y: node.y - 1, distance: node.distance + 1))
    }

    if node.y + 1 < rowsCount,
       isPathUsable(from: currentCharacter, to: matrix[node.y + 1][node.x]) {
        neighbours.append(.init(x: node.x, y: node.y + 1, distance: node.distance + 1))
    }

    return neighbours
}

func endOfTheRainbow(fromPosition startPosition: (x: Int, y: Int), matrix: [[Character]]) -> Int {
    let startNode = Node(x: startPosition.x, y: startPosition.y, distance: 0)
    var nodesQueue: [Node] = []
    var mutableMatrix = matrix

    nodesQueue.append(startNode)
    mutableMatrix[startPosition.y][startPosition.x] = "a"

    while !nodesQueue.isEmpty {
        let node = nodesQueue.removeFirst()

        if mutableMatrix[node.y][node.x] == "E" {
            return node.distance
        } else {
            nodesQueue.append(contentsOf: getNeighbours(from: node, in: mutableMatrix))
            mutableMatrix[node.y][node.x] = "."
        }
    }

    return -1
}

func partTwo(input: String) -> Int? {
    let matrix = input.split(separator: "\n")
        .map(String.init)
        .map { $0.map { $0 } }
    var distances: [Int] = []

    let aPositions = findPositions(of: "a", in: matrix)

    for aPosition in aPositions {
        distances.append(endOfTheRainbow(fromPosition: aPosition, matrix: matrix))
    }

    return distances
        .filter { $0 != -1 }
        .sorted()
        .first
}

func partOne(input: String) -> Int {
    let matrix = input.split(separator: "\n")
        .map(String.init)
        .map { $0.map { $0 } }

    let startPosition = findPositions(of: "S", in: matrix).first!

    return endOfTheRainbow(fromPosition: startPosition, matrix: matrix)
}

print(partTwo(input: input))
