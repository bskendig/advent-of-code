//
//  main.swift
//  12
//
//  Created by Brian Kendig on 12/12/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func getData() -> NSData {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("input", ofType: "txt")
    return NSData(contentsOfFile: path!)!
}

func readNumbersFrom(x: NSObject, ignoreRed: Bool = false) -> Int {
    var i = 0
    let className = x.className
    if className.rangeOfString("Array") != nil {
        for y in (x as! Array<NSObject>) {
            i += readNumbersFrom(y, ignoreRed: ignoreRed)
        }
    } else if className.rangeOfString("Dictionary") != nil {
        if !ignoreRed || !(x as! Dictionary<String, NSObject>).values.contains("red") {
            for y in (x as! Dictionary<String, NSObject>) {
                i += readNumbersFrom(y.1, ignoreRed: ignoreRed)
            }
        }
    } else if className.rangeOfString("Number") != nil {
        i = (x as! NSNumber).integerValue
    }
    return i
}

func main() {
    let jsonDict = try! NSJSONSerialization.JSONObjectWithData(getData(), options: []) as! NSObject
    print("Sum is \(readNumbersFrom(jsonDict))")
    print("Sum ignoring red is \(readNumbersFrom(jsonDict, ignoreRed: true))")
}

main()
