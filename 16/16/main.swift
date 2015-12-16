//
//  main.swift
//  16
//
//  Created by Brian Kendig on 12/16/15.
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
    let theRealSue = ["children": 3, "cats": 7, "samoyeds": 2, "pomeranians": 3, "akitas": 0, "vizslas": 0,
        "goldfish": 5, "trees": 3, "cars": 2, "perfumes": 1]

    let sues = getInput().componentsSeparatedByString("\n")
    let regex = try! NSRegularExpression(
        pattern: "^Sue (\\d+): (.+)$", options: []
    )
    findFirstSue: for sue in sues {
        let matches = regex.matchesInString(sue, options: [], range: NSMakeRange(0, sue.characters.count))
        if !matches.isEmpty {
            let a = getMatches(sue, matches: matches)
            let whichSue = a[0]
            for property in a[1].componentsSeparatedByString(", ") {
                let b = property.componentsSeparatedByString(": ")
                let p = b[0], val = Int(b[1])!
                if theRealSue[p] != val {
                    continue findFirstSue
                }
            }
            // if we made it here, we're good
            print("The first Sue is number \(whichSue).")
            break
        }
    }

    findSecondSue: for sue in sues {
        let matches = regex.matchesInString(sue, options: [], range: NSMakeRange(0, sue.characters.count))
        if !matches.isEmpty {
            let a = getMatches(sue, matches: matches)
            let whichSue = a[0]
            for property in a[1].componentsSeparatedByString(", ") {
                let b = property.componentsSeparatedByString(": ")
                let p = b[0], val = Int(b[1])!
                var okay = false
                switch p {
                case "cats", "trees":
                    okay = (theRealSue[p] < val)
                case "pomeranians", "goldfish":
                    okay = (theRealSue[p] > val)
                default:
                    okay = (theRealSue[p] == val)
                }
                if !okay {
                    continue findSecondSue
                }
            }
            // if we made it here, we're good
            print("The second Sue is number \(whichSue).")
            break
        }
    }
}

main()
