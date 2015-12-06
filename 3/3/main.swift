//
//  main.swift
//  3
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
    var house: [String: Int] = ["0,0": 1]
    var x = 0, y = 0

    let text = getInput()
    for step in text.characters {
        switch step {
            case ">": x++
            case "<": x--
            case "^": y++
            case "v": y--
            default: break
        }
        let key = String(format: "%d,%d", x, y)
        if (house[key] != nil) { house[key]!++ }
        else { house[key] = 1 }
    }
    print(String(format: "Santa delivers presents to %d houses", house.count))

    house = ["0,0": 2]
    var xa = [0, 0], ya = [0, 0]
    var i = 0
    for step in text.characters {
        switch step {
            case ">": xa[i]++
            case "<": xa[i]--
            case "^": ya[i]++
            case "v": ya[i]--
            default: break
        }
        let key = String(format: "%d,%d", xa[i], ya[i])
        if (house[key] != nil) { house[key]!++ }
        else { house[key] = 1 }
        i = (i + 1) % 2
    }
    print(String(format: "Santa and Robo-Santa deliver presents to %d houses", house.count))
}

main()
