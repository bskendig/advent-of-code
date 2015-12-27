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

func weightsToTotal(total: Int, weights: [Int], onlyNeedOne: Bool = false) -> [WeightCollection] {
    var workingCombinations: [WeightCollection] = []
    for (i, weight) in weights.enumerate() {
        let weightsBeforeThisOne = Array(weights[0 ..< i])
        let weightsAfterThisOne = Array(weights[i+1 ..< weights.count])
        if weight > total {
            continue
        } else if weight == total {
            let weightCollection = WeightCollection(used: [weight], leftover: weightsBeforeThisOne + weightsAfterThisOne)
            workingCombinations.append(weightCollection)
            if onlyNeedOne {
                break
            }
        } else {
            let weightCollections = weightsToTotal(total - weight, weights: weightsAfterThisOne, onlyNeedOne: onlyNeedOne)
            if !weightCollections.isEmpty {
                // just add weight to each of the weightCollections.used that we got back
                let newWeightCollections = weightCollections.map({ (var weightCollection: WeightCollection) -> WeightCollection in
                    weightCollection.used.append(weight)
                    weightCollection.leftover += weightsBeforeThisOne
                    return weightCollection
                })
                workingCombinations += newWeightCollections
                if onlyNeedOne && !workingCombinations.isEmpty {
                    break
                }
            }

        }

    }
    return workingCombinations
}

func main() {
    let weights = getInput().componentsSeparatedByString("\n").filter({ $0 != "" }).map({ Int($0)! })
    let sum = weights.reduce(0, combine: +)

    let oneThird = sum/3
    var solutions = weightsToTotal(oneThird, weights: weights)
    var solutionsThatCanBeDividedEvenly = solutions.filter({
        !weightsToTotal(oneThird, weights: $0.leftover, onlyNeedOne: true).isEmpty
    })
    var shortestListLength = solutionsThatCanBeDividedEvenly.minElement({ $0.used.count < $1.used.count })!.used.count
    var shortestSolutions = solutionsThatCanBeDividedEvenly.filter({ $0.used.count == shortestListLength })
    var smallestQuantumEntanglement = shortestSolutions.map({ $0.used.reduce(1, combine: *) }).minElement()!
    print("Smallest quantum entanglement for packages divided into three groups: \(smallestQuantumEntanglement)")

    let oneFourth = sum/4
    solutions = weightsToTotal(oneFourth, weights: weights)
    solutionsThatCanBeDividedEvenly = solutions.filter({
        // @todo: this should also check the third fourth
        !weightsToTotal(oneFourth, weights: $0.leftover, onlyNeedOne: true).isEmpty
    })
    shortestListLength = solutionsThatCanBeDividedEvenly.minElement({ $0.used.count < $1.used.count })!.used.count
    shortestSolutions = solutionsThatCanBeDividedEvenly.filter({ $0.used.count == shortestListLength })
    smallestQuantumEntanglement = shortestSolutions.map({ $0.used.reduce(1, combine: *) }).minElement()!
    print("Smallest quantum entanglement for packages divided into four groups: \(smallestQuantumEntanglement)")

}

main()
