//
//  main.swift
//  24
//
//  Created by Brian Kendig on 12/24/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

struct WeightCollection {
    var used: [Int]
    var leftover: [Int]
}

func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("input", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func weightsToTotal(total: Int, weights: [Int]) -> [WeightCollection] {
    var workingCombinations: [WeightCollection] = []
    for i in 0 ..< weights.count {
        var weightsWithOneRemoved = weights
        let weight: Int = weightsWithOneRemoved.removeAtIndex(i)
        if weight > total {
            continue
        } else if weight == total {
            let weightCollection = WeightCollection(used: [weight], leftover: weightsWithOneRemoved)
            workingCombinations.append(weightCollection)
        } else {
            let weightCollections = weightsToTotal(total - weight, weights: weightsWithOneRemoved)
            if !weightCollections.isEmpty {
                let newWeightCollections = weightCollections.map({ (weightCollection: WeightCollection) -> WeightCollection in
                    var newWeightCollection = weightCollection
                    var usedGroup = newWeightCollection.used
                    return usedGroup.app append(weight)
                })
            }

        }

    }
    return workingCombinations
}

func main() {
    let weights = getInput().componentsSeparatedByString("\n").filter({ $0 != "" }).map({ Int($0)! })
    print(weights)
    let sum = weights.reduce(0, combine: +)
    print(sum, sum/3)
//    1524 508
}

main()
