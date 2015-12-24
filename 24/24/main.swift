//
//  main.swift
//  24
//
//  Created by Brian Kendig on 12/24/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("input", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func weightsToTotal(total: Int, weights: [Int]) {

}

func main() {
    let weights = getInput().componentsSeparatedByString("\n").filter({ $0 != "" }).map({ Int($0)! })
    print(weights)
    let sum = weights.reduce(0, combine: +)
    print(sum, sum/3)
//    1524 508
}

main()
