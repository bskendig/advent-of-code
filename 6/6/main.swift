//
//  main.swift
//  6
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

func changeLights(command: String, x1: Int, y1: Int, x2: Int, y2: Int, var lights: [[Bool]]) -> [[Bool]] {
    for x in x1...x2 {
        for y in y1...y2 {
            switch command {
                case "turn on":  lights[x][y] = true
                case "turn off": lights[x][y] = false
                case "toggle":   lights[x][y] = !lights[x][y]
                default: break
            }
        }
    }
    return lights
}

func countLights(lights: [[Bool]]) -> Int {
    var c = 0
    for row in lights {
        c += row.filter({$0 == true}).count
    }
    return c
}

func changeBrightness(command: String, x1: Int, y1: Int, x2: Int, y2: Int, var lights: [[Int]]) -> [[Int]] {
    for x in x1...x2 {
        for y in y1...y2 {
            switch command {
                case "turn on":  lights[x][y]++
                case "turn off": lights[x][y] = max(--lights[x][y], 0)
                case "toggle":   lights[x][y] += 2
                default: break
            }
        }
    }
    return lights
}

func countBrightness(lights: [[Int]]) -> Int {
    var c = 0
    for row in lights {
        c += row.reduce(0, combine: +)
    }
    return c
}

func main() {
    let lines = getInput().componentsSeparatedByString("\n")

    var lightsPart1 = [[Bool]](count: 1000, repeatedValue: [Bool](count: 1000, repeatedValue: false))
    var lightsPart2 = [[Int]](count: 1000, repeatedValue: [Int](count: 1000, repeatedValue: 0))

    let regex = try! NSRegularExpression(pattern: "([^\\d]+) (\\d+),(\\d+) through (\\d+),(\\d+)", options: [])
    for line in lines {
        let matches = regex.matchesInString(line, options: [], range: NSMakeRange(0, line.characters.count))
        if !matches.isEmpty {
            let command = (line as NSString).substringWithRange(matches[0].rangeAtIndex(1))
            var a: [Int] = []
            for i in 2 ..< matches[0].numberOfRanges {
                let s = (line as NSString).substringWithRange(matches[0].rangeAtIndex(i))
                a.append(Int(s)!)
            }
            lightsPart1 = changeLights(command, x1: a[0], y1: a[1], x2: a[2], y2: a[3], lights: lightsPart1)
            lightsPart2 = changeBrightness(command, x1: a[0], y1: a[1], x2: a[2], y2: a[3], lights: lightsPart2)
        }
    }
    print(String(format: "%d total lights lit for part 1", countLights(lightsPart1)))
    print(String(format: "%d total brightness for part 2", countBrightness(lightsPart2)))
}

main()
