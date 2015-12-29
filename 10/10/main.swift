//
//  main.swift
//  10
//
//  Created by Brian Kendig on 12/10/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func iterate(inout a: [Int8], oldLength: Int) -> ([Int8], Int) {

    // allocate an array to write the new value into, rather than continuously appending
    let newLength = max(Int(Float(oldLength) * 1.5), 4)
    var newArray = [Int8](count: newLength, repeatedValue: 0)
    var bufferOffset = 0

    var prevInt: Int8 = a[0]
    var intCount: Int8 = 1

    for i in a[1 ..< oldLength] {
        if i == prevInt {
            intCount++
        } else {
            newArray[bufferOffset++] = intCount
            newArray[bufferOffset++] = prevInt
            prevInt = i
            intCount = 1
        }
    }
    newArray[bufferOffset++] = intCount
    newArray[bufferOffset++] = prevInt
//    newArray.removeRange(bufferOffset ..< newLength)
    return (newArray, bufferOffset)
}

func main() {
//    let input = "1113222113"
//    var a: [Int8] = input.characters.map({Int8($0)})
    var a: [Int8] = [1, 1, 1, 3, 2, 2, 2, 1, 1, 3]
    var len = a.count
    let start = NSDate().timeIntervalSince1970
    for i in 1...100 {
        (a, len) = iterate(&a, oldLength: len)
        print("\(i): \(NSDate().timeIntervalSince1970 - start) seconds, length = \(len)")
    }
}

main()
