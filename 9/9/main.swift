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

func distanceBetween(loc1: String, loc2: String, distance: [String:[String:Int]]) -> Int {
    return distance[loc1]![loc2] ?? distance[loc2]![loc1]!
}

func allPermutations(locations: [String]) -> [[String]] {
    if locations.count == 1 { return [locations] }
    var a: [String] = []
    for (i, loc) in locations.enumerate() {
        var locs = locations
        locs.removeAtIndex(i)
        return locs.map({$0.insert(loc, atIndex: 0)})
    }

    return []
}


func combinations<T>(var arr: Array<T>, k: Int) -> Array<Array<T>> {
    var i: Int
    var subI : Int
    var ret: Array<Array<T>> = []
    var sub: Array<Array<T>> = []
    var next: Array<T> = []
    for var i = 0; i < arr.count; ++i {
        if(k == 1){
            ret.append([arr[i]])
        }else {
            sub = combinations(sliceArray(arr, i + 1, arr.count – 1), k – 1)
            for var subI = 0; subI < sub.count; ++subI {
                next = sub[subI]
                next.insert(arr[i], atIndex: 0)
                ret.append(next)
            }
        }
    }
    return ret
}



func main() {
    var distance: [String:[String:Int]] = [:]
    var locations: [String:Bool] = [:]
    let distanceLines = getInput().componentsSeparatedByString("\n")
    for distanceLine in distanceLines {
        let regex = try! NSRegularExpression(pattern: "(.+) to (.+) = (\\d+)", options: [])
        let matches = regex.matchesInString(distanceLine, options: [], range: NSMakeRange(0, distanceLine.characters.count))
        if !matches.isEmpty {
            let a = getMatches(distanceLine, matches: matches)
            let loc1 = a[0], loc2 = a[1], d = Int(a[2])!
            var dict = distance[loc1] ?? [:]
            dict[loc2] = d
            distance[loc1] = dict
            locations[loc1] = true
            locations[loc2] = true
        }
    }

}

main()
