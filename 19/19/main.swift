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

    var countReplacements = 0
    for (molecule, replacementArray) in replacements {
        let regex = try! NSRegularExpression(pattern: molecule, options: [])
        let matches = regex.matchesInString(startingMolecule, options: [],
            range: NSMakeRange(0, startingMolecule.characters.count))
        if !matches.isEmpty {
            for i in 1 ..< matches[0].numberOfRanges {
                for replace in replacementArray {

                }
            }
        }

//        countReplacements += matches.count * replacementArray.count
    }

    print(countReplacements)

}

main()
