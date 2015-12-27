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
    for (i, weight) in weights.enumerate() {
        let weightsBeforeThisOne = Array(weights[0 ..< i])
        let weightsAfterThisOne = Array(weights[i+1 ..< weights.count])
        if weight > total {
            continue
        } else if weight == total {
            let weightCollection = WeightCollection(used: [weight], leftover: weightsBeforeThisOne + weightsAfterThisOne)
            workingCombinations.append(weightCollection)
        } else {
            let weightCollections = weightsToTotal(total - weight, weights: weightsAfterThisOne)
            if !weightCollections.isEmpty {
                // just add weight to each of the weightCollections.used that we got back
                let newWeightCollections = weightCollections.map({ (var weightCollection: WeightCollection) -> WeightCollection in
                    weightCollection.used.append(weight)
                    weightCollection.leftover += weightsBeforeThisOne
                    return weightCollection
                })
                workingCombinations += newWeightCollections
            }

        }

    }
    return workingCombinations
}

func main() {
    let weights = getInput().componentsSeparatedByString("\n").filter({ $0 != "" }).map({ Int($0)! })
    let sum = weights.reduce(0, combine: +)
    //    print(weights)
    //    print(sum, sum/3)
    //    1524 508

    print(weightsToTotal(20, weights: [1, 2, 3, 4, 5, 7, 8, 9, 10, 11]))

    //    print(weightsToTotal(sum/3, weights: weights))
    
}

main()
