//
//  main.swift
//  10
//
//  Created by Brian Kendig on 12/10/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func iterate(inout s: String) -> String {

    // allocate an array to write the new string into, rather than continuously appending to a string
    let newLength = Int(Float(s.characters.count) * 1.5)
    var newString = [UInt8](count: newLength, repeatedValue: 0)
    var bufferOffset = 0

    var prevChar: Character = s[s.startIndex]
    var charCount = 1

    for c in s.substringFromIndex(s.startIndex.advancedBy(1)).characters {
        if c == prevChar {
            charCount++
        } else {
            let cs = String(charCount)
            newString[bufferOffset++] = [UInt8](cs.utf8)[0]                // count
            newString[bufferOffset++] = [UInt8](String(prevChar).utf8)[0]  // previous char
            prevChar = c
            charCount = 1
        }
    }
    let cs = String(charCount)
    newString[bufferOffset++] = [UInt8](cs.utf8)[0]                // count
    newString[bufferOffset++] = [UInt8](String(prevChar).utf8)[0]  // previous char
    return NSString(bytes: newString, length: bufferOffset, encoding: NSUTF8StringEncoding) as! String
}

func main() {
    var input = "1113222113"

//    for _ in 1...40 {
//        input = iterate(&input)
//    }
//    print("After 40 iterations, we have \(input.characters.count) characters")
//    for _ in 41...50 {
//        input = iterate(&input)
//    }
//    print("After 50 iterations, we have \(input.characters.count) characters")

    for i in 1...100 {
        input = iterate(&input)
        print(i)
    }
}

main()
