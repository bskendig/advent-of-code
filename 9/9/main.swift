//
//  main.swift
//  9
//
//  Created by Brian Kendig on 12/9/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

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

func distanceBetween(loc1: String, loc2: String, allDistances: [String:[String:Int]]) -> Int {
    if (allDistances[loc1] != nil && allDistances[loc1]![loc2] != nil) {
        return allDistances[loc1]![loc2]!
    } else {
        return allDistances[loc2]![loc1]!
    }
}

// for each string in the array:
//     pull it off a copy of the array
//     add it to the beginning of every permutation of the rest of the array

func allPermutations(locations: [String]) -> [[String]] {
    if locations.count == 1 { return [locations] }
    var allResults: [[String]] = []
    for (i, loc) in locations.enumerate() {
        var locs = locations
        locs.removeAtIndex(i)
        let permutations = allPermutations(locs)
        let p = permutations.map({
            (a: [String]) -> [String] in
            var b = a
            b.insert(loc, atIndex: 0)
            return b
        })
        allResults += p
    }
    return allResults
}

func getTotalDistance(locations: [String], allDistances: [String:[String:Int]]) -> Int {
    var d = 0
    for i in 0 ..< locations.count - 1 {
        d += distanceBetween(locations[i], loc2: locations[i+1], allDistances: allDistances)
    }
    return d
}

func main() {
    var allDistances: [String:[String:Int]] = [:]
    var locations: [String:Bool] = [:]
    let distanceLines = getInput().componentsSeparatedByString("\n")
    for distanceLine in distanceLines {
        let regex = try! NSRegularExpression(pattern: "(.+) to (.+) = (\\d+)", options: [])
        let matches = regex.matchesInString(distanceLine, options: [], range: NSMakeRange(0, distanceLine.characters.count))
        if !matches.isEmpty {
            let a = getMatches(distanceLine, matches: matches)
            let loc1 = a[0], loc2 = a[1], d = Int(a[2])!
            var dict = allDistances[loc1] ?? [:]
            dict[loc2] = d
            allDistances[loc1] = dict
            locations[loc1] = true
            locations[loc2] = true
        }
    }

    let allLocationPermutations = allPermutations(Array(locations.keys))
    var min = 99999
    var foundRoute: [String] = []
    for p in allLocationPermutations {
        let d = getTotalDistance(p, allDistances: allDistances)
        if d < min {
            min = d
            foundRoute = p
        }
    }
    var routeString = foundRoute.joinWithSeparator(" -> ")
    print("Shortest route is \(min): \(routeString)")

    var max = 0
    foundRoute = []
    for p in allLocationPermutations {
        let d = getTotalDistance(p, allDistances: allDistances)
        if d > max {
            max = d
            foundRoute = p
        }
    }
    routeString = foundRoute.joinWithSeparator(" -> ")
    print("Shortest route is \(max): \(routeString)")
}

main()
