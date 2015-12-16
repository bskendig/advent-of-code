//
//  main.swift
//  15
//
//  Created by Brian Kendig on 12/15/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

var ingredients: [String:[Int]] = [:]
var maxScore: (Int, [String:Int]) = (0, [:])
var with500Calories: [(Int, [String:Int])] = []


func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("input", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func getMatches(s: String, matches: [NSTextCheckingResult]) -> [String] {
    var a: [String] = []
    for i in 1 ..< matches[0].numberOfRanges {
        a.append((s as NSString).substringWithRange(matches[0].rangeAtIndex(i)))
    }
    return a
}

func total(ingredientQuantities: [String:Int]) -> (Int, Int) {
    // ingredientQuantities = ["Frosting": 1, "Candy": 2, ...]
    var ingredientPropertyTotals = [Int](count: 5, repeatedValue: 0)  // because we have 5 different properties
    // ingredientPropertyTotals = [0, 0, 0, 0, 0]
    for (ingredientName, ingredientQuantity) in ingredientQuantities {
        for i in 0 ... ingredientPropertyTotals.count - 1 {
            ingredientPropertyTotals[i] += ingredients[ingredientName]![i] * ingredientQuantity
        }
    }
    let calories = ingredientPropertyTotals.removeLast()
    return (ingredientPropertyTotals.map({ max($0, 0) }).reduce(1, combine: *), calories)
}

func tryIngredients(quantities: [String:Int], remainingQuantity: Int, remainingIngredients: [String]) -> Int {
    if remainingIngredients.count == 1 {
        var newQuantities = quantities
        newQuantities[remainingIngredients[0]] = remainingQuantity
        let (score, calories) = total(newQuantities)
        if score > maxScore.0 { maxScore = (score, newQuantities) }
        if calories == 500 { with500Calories.append((score, newQuantities)) }
    } else {
        for i in 0 ... remainingQuantity {
            var newQuantities = quantities
            var stillRemainingIngredients = remainingIngredients
            let nextIngredient = stillRemainingIngredients.removeFirst()
            newQuantities[nextIngredient] = i
            tryIngredients(
                newQuantities, remainingQuantity: remainingQuantity - i, remainingIngredients: stillRemainingIngredients
            )
        }
    }
    return 0
}

func main() {
    let ingredientLines = getInput().componentsSeparatedByString("\n")
    // (example) Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5
    let regex = try! NSRegularExpression(
        pattern: "^(.+): capacity (.+), durability (.+), flavor (.+), texture (.+), calories (.+)$", options: []
    )
    for line in ingredientLines {
        let matches = regex.matchesInString(line, options: [], range: NSMakeRange(0, line.characters.count))
        if !matches.isEmpty {
            var a = getMatches(line, matches: matches)
            ingredients[a[0]] = [Int(a[1])!, Int(a[2])!, Int(a[3])!, Int(a[4])!, Int(a[5])!]
        }
    }

    tryIngredients([:], remainingQuantity: 100, remainingIngredients: Array(ingredients.keys))

    print("Best cookie: \(maxScore.1) with a score of \(maxScore.0).")
    let part2Answer = with500Calories.maxElement({ $0.0 < $1.0 })
    print("500-calorie cookie: \(part2Answer!.1) with a score of \(part2Answer!.0).")
}

main()
