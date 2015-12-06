//
//  main.swift
//  2
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
    let presents = getInput().componentsSeparatedByString("\n")
    var paper = 0, ribbon = 0

    for present in presents {
        let d = present.componentsSeparatedByString("x").map { Int($0) ?? 0 }.sort()
        if (d.count == 1) { continue }
        paper += (3 * d[0] * d[1]) + (2 * d[1] * d[2]) + (2 * d[0] * d[2])
        ribbon += (2 * d[0]) + (2 * d[1]) + (d[0] * d[1] * d[2])
    }

    print(String(format: "Paper = %d, Ribbon = %d", paper, ribbon))
}

main()
