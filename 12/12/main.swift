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

func addNumbersFrom(x: NSObject, ignoreRed: Bool = false) -> Int {
    var i = 0
    if let a = x as? [NSObject] {
        i += a.map({addNumbersFrom($0, ignoreRed: ignoreRed)}).reduce(0, combine: +)
    } else if let d = x as? [String:NSObject] {
        if !ignoreRed || !d.values.contains("red") {
            i += d.values.map({addNumbersFrom($0, ignoreRed: ignoreRed)}).reduce(0, combine: +)
        }
    } else if let n = x as? Int {
        i = n
    }
    return i
}

func main() {
    let jsonDict = try! NSJSONSerialization.JSONObjectWithData(getData(), options: []) as! NSObject
    print("Sum is \(addNumbersFrom(jsonDict))")
    print("Sum ignoring red is \(addNumbersFrom(jsonDict, ignoreRed: true))")
}

main()
