//
//  main.swift
//  15
//
//  Created by Brian Kendig on 12/15/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

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

func total(frostingAmount: Int, candyAmount: Int, butterscotchAmount: Int, sugarAmount: Int,
    ingredients: [String:(Int, Int, Int, Int, Int)]) -> (Int, Int) {
        let totalCapacity = ingredients["Frosting"]!.0 * frostingAmount
            + ingredients["Candy"]!.0 * candyAmount
            + ingredients["Butterscotch"]!.0 * butterscotchAmount
            + ingredients["Sugar"]!.0 * sugarAmount
        let totalDurability = ingredients["Frosting"]!.1 * frostingAmount
            + ingredients["Candy"]!.1 * candyAmount
            + ingredients["Butterscotch"]!.1 * butterscotchAmount
            + ingredients["Sugar"]!.1 * sugarAmount
        let totalFlavor = ingredients["Frosting"]!.2 * frostingAmount
            + ingredients["Candy"]!.2 * candyAmount
            + ingredients["Butterscotch"]!.2 * butterscotchAmount
            + ingredients["Sugar"]!.2 * sugarAmount
        let totalTexture = ingredients["Frosting"]!.3 * frostingAmount
            + ingredients["Candy"]!.3 * candyAmount
            + ingredients["Butterscotch"]!.3 * butterscotchAmount
            + ingredients["Sugar"]!.3 * sugarAmount
        let totalCalories = ingredients["Frosting"]!.4 * frostingAmount
            + ingredients["Candy"]!.4 * candyAmount
            + ingredients["Butterscotch"]!.4 * butterscotchAmount
            + ingredients["Sugar"]!.4 * sugarAmount
        return (max(totalCapacity, 0) * max(totalDurability, 0) * max(totalFlavor, 0) * max(totalTexture, 0), totalCalories)
}

func main() {
    var ingredients: [String:(Int, Int, Int, Int, Int)] = [:]
    let ingredientLines = getInput().componentsSeparatedByString("\n")
    // Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5
    let regex = try! NSRegularExpression(
        pattern: "^(.+): capacity (.+), durability (.+), flavor (.+), texture (.+), calories (.+)$", options: []
    )
    for line in ingredientLines {
        let matches = regex.matchesInString(line, options: [], range: NSMakeRange(0, line.characters.count))
        if !matches.isEmpty {
            var a = getMatches(line, matches: matches)
            ingredients[a[0]] = (Int(a[1])!, Int(a[2])!, Int(a[3])!, Int(a[4])!, Int(a[5])!)
        }
    }

    var max = 0
    var with500Calories: [Int] = []
    for a in 0 ... 100 {
        for b in 0 ... (100 - a) {
            for c in 0 ... (100 - a - b) {
                let d = 100 - a - b - c
                let (totalScore, calories) = total(a, candyAmount: b, butterscotchAmount: c, sugarAmount: d, ingredients: ingredients)
                //print("\(a), \(b), \(c), \(d) -> \(totalScore)")
                if totalScore > max { max = totalScore }
                if calories == 500 { with500Calories.append(totalScore) }
            }
        }
    }
    print(max)
    print(with500Calories.maxElement())
}

main()
