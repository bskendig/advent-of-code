//
//  main.swift
//  15
//
//  Created by Brian Kendig on 12/15/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

var ingredients: [String:[Int]] = [:]
var maxScore = 0
var with500Calories: [Int] = []


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

// tryIngredients([], remainingQuantity: 100, remainingIngredientCount: 4)
/*
func tryIngredients(quantities: [String:Int], remainingQuantity: Int, remainingIngredients: [String]) -> Int {
    if remainingIngredientCount == 1 {
        var newQuantities = quantities
        newQuantities.append(remainingQuantity)
        let score = total(quantities)
        print(newQuantities)
    } else {
        for i in 0 ... remainingQuantity {
            var newQuantities = quantities
            newQuantities.append(i)
            tryIngredients(
                newQuantities, remainingQuantity: remainingQuantity - i, remainingIngredientCount: remainingIngredientCount - 1
            )
        }
    }
    return 0
}
*/

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

//    let x = total(["Frosting": 25, "Candy": 25, "Butterscotch": 25, "Sugar": 25])
//    let x = total(["Butterscotch": 1, "Cinnamon": 1])

    //    tryIngredients([], remainingQuantity: 100, remainingIngredientCount: 4)
    //    exit(0)
    
    for a in 0 ... 100 {
        for b in 0 ... (100 - a) {
            for c in 0 ... (100 - a - b) {
                let d = 100 - a - b - c
                let (totalScore, calories) = total(["Frosting": a, "Candy": b, "Butterscotch": c, "Sugar": d])
                print("\(a), \(b), \(c), \(d) -> \(totalScore)")
                if totalScore > maxScore { maxScore = totalScore }
                if calories == 500 { with500Calories.append(totalScore) }
            }
        }
    }
    print(maxScore)
    print(with500Calories.maxElement())
}

main()
