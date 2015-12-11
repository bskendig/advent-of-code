//
//  main.swift
//  10
//
//  Created by Brian Kendig on 12/10/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func iterate(inout a: [Int8]) -> [Int8] {

    // allocate an array to write the new value into, rather than continuously appending
    let newLength = Int(Float(a.count) * 2)
    var newArray = [Int8](count: newLength, repeatedValue: 0)
    var bufferOffset = 0

    var prevInt: Int8 = a[0]
    var intCount: Int8 = 1

    for i in a[1 ..< a.count] {
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
    newArray.removeRange(bufferOffset ..< newLength)
    return newArray
}

func main() {
//    let input = "1113222113"
//    var a: [Int8] = input.characters.map({Int8($0)})
    var a: [Int8] = [1, 1, 1, 3, 2, 2, 2, 1, 1, 3]
    
//    for _ in 1...40 {
//        a = iterate(&a)
//    }
//    print("After 40 iterations, we have \(a.count) characters")
//    for _ in 41...50 {
//        a = iterate(&a)
//    }
//    print("After 50 iterations, we have \(a.count) characters")

    for i in 1...100 {
        a = iterate(&a)
        print(i)
    }
}

main()
