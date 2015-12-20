//
//  main.swift
//  19
//
//  Created by Brian Kendig on 12/19/15.
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

func allMoleculesFrom(startingMolecule: String, replacements: [String:[String]], limit: Int = -1) -> [String] {
    var replacementStrings: [String] = []
    for (molecule, replacementArray) in replacements {
        let newRegex = try! NSRegularExpression(pattern: "(" + molecule + ")", options: [])
        let matches = newRegex.matchesInString(startingMolecule, options: [],
            range: NSMakeRange(0, startingMolecule.characters.count))
        if !matches.isEmpty {
            for match in matches {
                for i in 1 ..< match.numberOfRanges {
                    for replacementString in replacementArray {
                        let newString = newRegex.stringByReplacingMatchesInString(
                            startingMolecule, options: [], range: match.rangeAtIndex(i), withTemplate: replacementString
                        )
                        if limit == -1 || newString.characters.count <= limit {
                            replacementStrings.append(newString)
                        }
                    }
                }
            }
        }
    }
    return replacementStrings
}

func main() {
    let lines = getInput().componentsSeparatedByString("\n")
    var replacements: [String:[String]] = [:]
    var startingMolecule = ""
    let regex = try! NSRegularExpression(pattern: "(.+) => (.+)", options: [])
    for line in lines {
        if line == "" { continue }
        let matches = regex.matchesInString(line, options: [], range: NSMakeRange(0, line.characters.count))
        if !matches.isEmpty {
            let a = getMatches(line, matches: matches)
            var replacementList = replacements[a[0]] ?? []
            replacementList.append(a[1])
            replacements[a[0]] = replacementList
        } else {
            startingMolecule = line
        }
    }

    // part 1
    let replacementStrings = allMoleculesFrom(startingMolecule, replacements: replacements)
    print("\(Set(replacementStrings).count) distinct molecules after one change.")

    // part 2, working backwards and assuming there's only one path
    var changes = 0
    while startingMolecule.characters.count > 1 {
        for (molecule, replacementArray) in replacements {
            for replacement in replacementArray {
                let newRegex = try! NSRegularExpression(pattern: "(" + replacement + ")", options: [])
                let matches = newRegex.matchesInString(startingMolecule, options: [],
                    range: NSMakeRange(0, startingMolecule.characters.count))
                if !matches.isEmpty {
                    changes += matches.count
                    startingMolecule = newRegex.stringByReplacingMatchesInString(
                        startingMolecule, options: [], range: NSMakeRange(0, startingMolecule.characters.count), withTemplate: molecule
                    )
                }
            }
        }
    }
    print("\(changes) changes to get to the desired molecule.")
}

main()
