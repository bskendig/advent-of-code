//
//  main.swift
//  13
//
//  Created by Brian Kendig on 12/13/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("input", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func getPeople(peopleLines: [String]) -> [String:[String:Int]] {
    var people: [String:[String:Int]] = [:]
    let regex = try! NSRegularExpression(
        pattern: "(.+) would (.+) (\\d+) happiness units by sitting next to (.+)\\.", options: []
    )
    for line in peopleLines {
        let matches = regex.matchesInString(line, options: [], range: NSMakeRange(0, line.characters.count))
        if !matches.isEmpty {
            var a: [String] = []
            for i in 1 ..< matches[0].numberOfRanges {
                a.append((line as NSString).substringWithRange(matches[0].rangeAtIndex(i)))
                // example: Alice, gain, 2, Bob
            }
            let change = Int(a[2])! * ((a[1] == "gain") ? 1 : -1)
            var dict = people[a[0]] ?? [:]
            dict[a[3]] = change
            people[a[0]] = dict
        }
    }
    return people
}

func getHappinessBetween(from: String, to: String, people: [String:[String:Int]]) -> Int {
    return ((people[from] != nil) ? (people[from]![to] ?? 0) : 0)
        + ((people[to] != nil) ? (people[to]![from] ?? 0) : 0)
}

func allPermutations<T>(locations: [T]) -> [[T]] {
    if locations.count == 1 { return [locations] }
    var allResults: [[T]] = []
    for (i, loc) in locations.enumerate() {
        var locs = locations
        locs.removeAtIndex(i)
        let permutations = allPermutations(locs)
        let p = permutations.map({
            (a: [T]) -> [T] in
            var b = a
            b.insert(loc, atIndex: 0)
            return b
        })
        allResults += p
    }
    return allResults
}

func getTotalHappiness(names: [String], people: [String:[String:Int]]) -> Int {
    var h = getHappinessBetween(names[0], to: names[names.count-1], people: people)
    for i in 0 ..< names.count - 1 {
        h += getHappinessBetween(names[i], to: names[i+1], people: people)
    }
    return h
}

func main() {
    let people = getPeople(getInput().componentsSeparatedByString("\n"))
    var permutations = allPermutations(Array(people.keys))

    var max = 0
    var happinessChange: [String] = []
    for p in permutations {
        let d = getTotalHappiness(p, people: people)
        if d > max {
            max = d
            happinessChange = p
        }
    }
    var happinessString = happinessChange.joinWithSeparator(", ")
    print("Happiest seating is \(max): \(happinessString)")

    permutations = allPermutations(Array(people.keys) + ["me"])
    max = 0
    happinessChange = []
    for p in permutations {
        let d = getTotalHappiness(p, people: people)
        if d > max {
            max = d
            happinessChange = p
        }
    }
    happinessString = happinessChange.joinWithSeparator(", ")
    print("Happiest seating with me is \(max): \(happinessString)")
}

main()
