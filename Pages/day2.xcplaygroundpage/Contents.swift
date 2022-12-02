var input = """
"""

enum Game: String, Comparable {
    case rock
    case paper
    case scisors

    init?(rawValue: String) {
        switch rawValue {
        case "X", "A":
            self = .rock
        case "Y", "B":
            self = .paper
        case "Z", "C":
            self = .scisors
        default:
            return nil
        }
    }

    var value: Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .scisors:
            return 3
        }
    }

    static func < (lhs: Game, rhs: Game) -> Bool {
        switch (lhs, rhs) {
        case (.rock, .paper), (.paper, .scisors), (.scisors, .rock):
            return true
        default:
            return false
        }
    }
}

func getScore(opponent: Game, mine: Game) -> Int {
    var score: Int = mine.value

    if opponent < mine {
        score += 6
    } else if opponent == mine {
        score += 3
    }

    return score
}

func pickGame(for opponent: Game, strategy: String) -> Game {
    switch opponent {
    case .scisors:
        if strategy == "X" {
            return .paper
        } else if strategy == "Y" {
            return .scisors
        } else {
            return .rock
        }
    case .paper:
        if strategy == "X" {
            return .rock
        } else if strategy == "Y" {
            return .paper
        } else {
            return .scisors
        }
    case .rock:
        if strategy == "X" {
            return .scisors
        } else if strategy == "Y" {
            return .rock
        } else {
            return .paper
        }
    }
}

func getScore(forRound round: String) -> Int {
    let roundSplited = round.split(separator: " ")
    guard let opponent = Game(rawValue: String(roundSplited[0])),
          let mine = Game(rawValue: String(roundSplited[1])) else { return 0 }

    return getScore(opponent: opponent, mine: mine)
}

func getScore2(forRound round: String) -> Int {
    let roundSplited = round.split(separator: " ")
    guard let opponent = Game(rawValue: String(roundSplited[0])) else { return 0 }
    let mine = pickGame(for: opponent, strategy: String(roundSplited[1]))

    return getScore(opponent: opponent, mine: mine)
}

func getRoundsScores(for input: String) -> Int {
    let rounds = input.split(separator: "\n")
    let totalScores = rounds
        .map { getScore2(forRound: String($0)) }
        .reduce(0, +)

    return totalScores
}

print(getRoundsScores(for: input))
