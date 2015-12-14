//
//  main.swift
//  14
//
//  Created by Brian Kendig on 12/14/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

struct Reindeer {
    var name: String
    var speed: Int
    var flying: Int
    var resting: Int
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

func distance(reindeer: Reindeer, atTime: Int) -> Int {
    return (atTime / (reindeer.flying + reindeer.resting)) * (reindeer.speed * reindeer.flying)
        + min(atTime % (reindeer.flying + reindeer.resting), reindeer.flying) * reindeer.speed
}

func getDistances(reindeer: [Reindeer], atTime: Int) -> [Int:[String]] {
    var distances: [Int:[String]] = [:]
    for reindeer in reindeer {
        let d = distance(reindeer, atTime: atTime)
        if distances[d] == nil { distances[d] = [] }
        distances[d]!.append(reindeer.name)
    }
    return distances
}

func main() {
    let reindeerLines = getInput().componentsSeparatedByString("\n")
    var allDeer: [Reindeer] = []
    let raceLength = 2503

    // Vixen can fly 19 km/s for 7 seconds, but then must rest for 124 seconds.
    let regex = try! NSRegularExpression(
        pattern: "^(.+) can fly (\\d+) km/s for (\\d+) seconds, but then must rest for (\\d+) seconds.$", options: []
    )
    for line in reindeerLines {
        let matches = regex.matchesInString(line, options: [], range: NSMakeRange(0, line.characters.count))
        if !matches.isEmpty {
            // Vixen, 19, 7, 124
            let a = getMatches(line, matches: matches)
            let reindeer = Reindeer(name: a[0], speed: Int(a[1])!, flying: Int(a[2])!, resting: Int(a[3])!)
            allDeer.append(reindeer)
        }
    }

    var distances = getDistances(allDeer, atTime: raceLength)
    let (winningDistance, winningDeer1) = distances.maxElement({ (a, b) -> Bool in
        return a.0 < b.0
    })!
    print("First race winner: \(winningDeer1.joinWithSeparator(" and ")) at \(winningDistance) km.")

    var points: [String:Int] = [:]
    for reindeer in allDeer {
        points[reindeer.name] = 0
    }
    for t in 1 ... raceLength {
        distances = getDistances(allDeer, atTime: t)
        let bestDistance = distances.keys.maxElement()
        for name in distances[bestDistance!]! {
            points[name]!++
        }
    }
    let winningScore = points.values.maxElement()!
    let winningDeer2 = points.filter({ $0.1 == winningScore }).map({ $0.0 })
    print("Second race winner: \(winningDeer2.joinWithSeparator(" and ")) with \(winningScore) points.")
}

main()
