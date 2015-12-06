//
//  main.swift
//  1
//
//  Created by Brian Kendig on 12/5/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("input", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func main() {
    let text = getInput()
    var floor = 0, firstBasementStep = -1
    for (i, c) in text.characters.enumerate() {
        if c == "(" { floor++ }
        else if c == ")" { floor-- }
        if (floor < 0 && firstBasementStep == -1) { firstBasementStep = i+1 }
    }
    print(String(format: "Ends on floor %d, first basement step is %d", floor, firstBasementStep))
}

main()
