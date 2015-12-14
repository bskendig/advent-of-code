//
//  main.swift
//  14
//
//  Created by Brian Kendig on 12/14/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

struct Reindeer {
    var speed: Int
    var flying: Int
    var resting: Int
    var points: Int
}

func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("input", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func getMatches(s: String, matches: [NSTextCheckingResult]) -> [String] {
    var a: [String] = []
    for i in 1 ..< matches[0].numberOfRanges {
        a.append((s as NSString).substringWithRange(matches[0].rangeAtIndex(i)))
    }
    return a
}

func distance(reindeer: Reindeer, time: Int) -> Int {
    return (time / (reindeer.flying + reindeer.resting)) * (reindeer.speed * reindeer.flying)
        + min(time % (reindeer.flying + reindeer.resting), reindeer.flying) * reindeer.speed
}

func main() {
    let reindeerLines = getInput().componentsSeparatedByString("\n")
    let raceLength = 2503
    var winningName = ""
    var winningDistance = 0
    var allDeer: [String:Reindeer] = [:]

    // Vixen can fly 19 km/s for 7 seconds, but then must rest for 124 seconds.
    let regex = try! NSRegularExpression(
        pattern: "^(.+) can fly (\\d+) km/s for (\\d+) seconds, but then must rest for (\\d+) seconds.$", options: []
    )
    for line in reindeerLines {
        let matches = regex.matchesInString(line, options: [], range: NSMakeRange(0, line.characters.count))
        if !matches.isEmpty {
            // Vixen, 19, 7, 124
            let a = getMatches(line, matches: matches)
            let name = a[0], reindeer = Reindeer(speed: Int(a[1])!, flying: Int(a[2])!, resting: Int(a[3])!, points: 0)
            allDeer[name] = reindeer
            let d = distance(reindeer, time: raceLength)
            if (d > winningDistance) {
                winningDistance = d
                winningName = name
            }
        }
    }
    print("\(winningName): \(winningDistance)")

    for t in 1 ... raceLength {
        var distances: [Int:[String]] = [:]
        for (name, reindeer) in allDeer {
            let d = distance(reindeer, time: t)
            if distances[d] == nil { distances[d] = [] }
            distances[d]!.append(name)
        }
        let bestDistance = distances.keys.maxElement()
        for name in distances[bestDistance!]! {
            allDeer[name]!.points++
        }
    }
//    winningName = allDeer.maxElement({$0.1.points < $1.1.points})
    print(winningName)
    print(allDeer)
}

main()
