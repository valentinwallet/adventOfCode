import Foundation

let realInput = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!,
                           encoding: String.Encoding.utf8)

let sampleInput = """
"""

struct File {
    let name: String
    let size: Int?
}

final class Directory {
    let name: String
    var files: [File]
    var children: [Directory]
    weak var parent: Directory?

    init(name: String) {
        self.name = name
        self.files = []
        self.children = []
    }

    func addChild(_ directory: Directory) {
        self.children.append(directory)
        directory.parent = self
    }

    func getChildDirectory(for name: String) -> Directory? {
        for child in children {
            if child.name == name {
                return child
            }
        }

        return nil
    }
}

func getDirectorySize(from root: Directory) -> Int {
    var size: Int = 0
    let directorySize = root.files.compactMap(\.size).reduce(0, +)

    for directoryChildren in root.children {
        size += getDirectorySize(from: directoryChildren)
    }

    return size + directorySize
}

func getDirectories(from root: Directory, limit: Int = 100000) -> [Directory] {
    var directories: [Directory] = []

    for directoryChildren in root.children {
        directories.append(contentsOf: getDirectories(from: directoryChildren))
    }

    directories.append(root)
    return directories
}

func createDirectories(from instructions: [[String]]) -> Directory {
    let rootDirectory: Directory = Directory(name: "/")
    var currentNode: Directory = rootDirectory
    var i = 0

    while i < instructions.count {
        if instructions[i][1] == "cd" {
            if instructions[i][2] == ".." {
                if let parentDirectory = currentNode.parent {
                    currentNode = parentDirectory
                }
            } else {
                if let childDirectory = currentNode.getChildDirectory(for: instructions[i][2]) {
                    currentNode = childDirectory
                }
            }

            i += 1
        } else if instructions[i][1] == "ls" {
            i += 1

            while i < instructions.count {
                if instructions[i][0] == "$" {
                    break
                }

                if instructions[i][0] == "dir" {
                    let directory = Directory(name: instructions[i][1])
                    currentNode.addChild(directory)
                } else {
                    let file = File(name: instructions[i][1], size: Int(instructions[i][0]))
                    currentNode.files.append(file)
                }

                i += 1
            }
        }
    }

    return rootDirectory
}

func partTwo(input: String) -> Int {
    let instructions = input
        .split(separator: "\n")
        .dropFirst()
        .map { String($0) }
        .map { $0.split(separator: " ").map(String.init) }

    let rootDirectory = createDirectories(from: instructions)
    let spaceGoal = 30000000
    let spaceAvailable = 70000000
    let actualSpace = 70000000 - getDirectorySize(from: rootDirectory)

    let sizes = getDirectories(from: rootDirectory)
        .map { directory in
            return getDirectorySize(from: directory)
        }
        .sorted()

    for size in sizes {
        if actualSpace + size > spaceGoal {
            return size
        }
    }

    return 0
}

func partOne(input: String) -> Int {
    let instructions = input
        .split(separator: "\n")
        .dropFirst()
        .map { String($0) }
        .map { $0.split(separator: " ").map(String.init) }

    let rootDirectory = createDirectories(from: instructions)

    return getDirectories(from: rootDirectory)
        .map { directory in
            let directorySize = getDirectorySize(from: directory)
            return directorySize <= 100000 ? directorySize : 0
        }
        .reduce(0, +)
}

print(partTwo(input: realInput))




