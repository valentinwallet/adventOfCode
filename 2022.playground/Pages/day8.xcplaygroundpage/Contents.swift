import Foundation

let realInput = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!,
                           encoding: String.Encoding.utf8)

let sampleInput = """
"""

struct Tree {
    let size: Int
    let left: String?
    let right: String?
    let top: String?
    let bottom: String?

    func isVisibible() -> Bool {
        guard let left = self.left,
              let right = self.right,
              let top = self.top,
              let bottom = self.bottom else {
            return true
        }

        return isTreeBigger(in: left) || isTreeBigger(in: right) || isTreeBigger(in: top) || isTreeBigger(in: bottom)
    }

    func isTreeBigger(in line: String) -> Bool {
        line
            .compactMap(\.wholeNumberValue)
            .filter {
                return $0 >= self.size
            }
            .isEmpty
    }

    func scenicScore() -> Int {
        let left = self.left != nil ? String(self.left!.reversed()) : nil
        let top = self.top != nil ? String(self.top!.reversed()) : nil

        let leftScore = self.getViewingTreeCount(in: left)
        let rightScore = self.getViewingTreeCount(in: self.right)
        let topScore = self.getViewingTreeCount(in: top)
        let bottomScore = self.getViewingTreeCount(in: self.bottom)

        return leftScore * rightScore * topScore * bottomScore
    }

    func getViewingTreeCount(in line: String?) -> Int {
        guard let line = line else { return 0 }
        var count = 0
        let treeLine = line.compactMap(\.wholeNumberValue)

        for treeSize in treeLine {
            count += 1

            if treeSize >= self.size {
                break
            }
        }

        return count
    }
}

func getTrees(from input: String) -> [Tree] {
    let treeLines = input.split(separator: "\n")
        .map(String.init)
    var trees: [Tree] = []
    var i = 0

    while i < treeLines.count {
        var j = 0

        while j < treeLines[i].count {
            if let size = Int(treeLines[i][j]) {
                let left = j > 0 ? treeLines[i].substring(withRange: 0..<j) : nil
                let right = j < treeLines[i].count - 1 ? treeLines[i].substring(withRange: j + 1..<treeLines[i].count) : nil
                let top = i > 0 ? treeLines[0...i - 1].map { $0[j] }.reduce("", +) : nil
                let bottom = i < treeLines.count - 1 ? treeLines[i + 1..<treeLines.count].map { $0[j] }.reduce("", +) : nil

                trees.append(.init(size: size, left: left, right: right, top: top, bottom: bottom))
            }
            j += 1
        }

        i += 1
    }

    return trees
}

func partOne(input: String) -> Int {
    return getTrees(from: input)
        .map { $0.isVisibible() }
        .reduce(0) { partialResult, isVisible in
            return isVisible ? partialResult + 1 : partialResult
        }
}

func partTwo(input: String) -> Int? {
    return getTrees(from: input)
        .map { return $0.scenicScore() }
        .max()
}

print(partTwo(input: realInput))




