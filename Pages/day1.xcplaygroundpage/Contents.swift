import UIKit

let input = """
"""

func putCaloriesInArray(input: String) -> [Int] {
    let calories = input
        .split(separator: "\n", omittingEmptySubsequences: false)
        .split(separator: "")
        .map { elfe in
            elfe.reduce(0) { partialResult, calorie in
                return partialResult + (Int(calorie) ?? 0)
            }
        }

    return calories
}

func sortCalories(calories: [Int]) -> [Int] {
    calories.sorted { a, b in
        a > b
    }
}

let calories = putCaloriesInArray(input: input)
let sortedCalories = sortCalories(calories: calories)

print(sortedCalories[0...2])
