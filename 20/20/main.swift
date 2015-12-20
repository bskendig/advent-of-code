//
//  main.swift
//  20
//
//  Created by Brian Kendig on 12/20/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func divisorsOf(n: Int, limit: Int = 0) -> [Int] {
    var d: [Int] = []
    var i = 1
    while i <= Int(sqrt(Double(n))) {
        if n % i == 0 {
            let j = n/i
            if limit == 0 || j <= limit { d.append(i) }
            if i != j && (limit == 0 || i <= limit) { d.append(j) }
        }
        i++
    }
    return d
}

func main() {
    let goal = 29000000
    var i = 0, firstHouse = 0, secondHouse = 0
    while firstHouse == 0 || secondHouse == 0 {
        i++
        if firstHouse == 0 && divisorsOf(i).reduce(0, combine: +) * 10 >= goal {
            firstHouse = i
            print("First house is \(firstHouse).")
        }
        if secondHouse == 0 && divisorsOf(i, limit: 50).reduce(0, combine: +) * 11 >= goal {
            secondHouse = i
            print("Second house is \(secondHouse).")
        }
    }
}

main()
