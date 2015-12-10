//
//  main.swift
//  10
//
//  Created by Brian Kendig on 12/10/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func iterate(s: String) -> String {
    var new = ""
    var prev: Character = " "
    var count = 0
    for c in s.characters {
        if c == prev {
            count++
        } else {
            if count != 0 { new += "\(count)\(prev)" }  // starting condition
            prev = c
            count = 1
        }
    }
    new += "\(count)\(prev)"
    return new
}

func main() {
    var input = "1113222113"
    for _ in 1...40 {
        input = iterate(input)
    }
    print("After 40 iterations, we have \(input.characters.count) characters")
    for _ in 1...10 {
        input = iterate(input)
    }
    print("After 50 iterations, we have \(input.characters.count) characters")
}

main()
