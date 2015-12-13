//
//  main.swift
//  11
//
//  Created by Brian Kendig on 12/12/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func increment(inout s: String, skip: [Character] = [], position: Int = 0) -> String {
    var c = s[s.endIndex.advancedBy(-position-1)] as Character
    if (c == "z") {
        c = "a"
        increment(&s, skip: skip, position: position + 1)
    } else {
        let scalars = String(c).unicodeScalars
        var val = scalars[scalars.startIndex].value
        repeat {
            c = Character(UnicodeScalar(++val))
        } while skip.contains(c)
    }
    let endPos = s.endIndex.advancedBy(-position-1)
    s.replaceRange(endPos ... endPos, with: String(c))
    return s
}

func isGood(s: String) -> Bool {
    //  Passwords may not contain the letters i, o, or l, as these letters can be mistaken for other characters
    //    and are therefore confusing.
    //  Passwords must include one increasing straight of at least three letters,
    //    like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't count.
    //  Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.

    let patterns: [String:Bool] = [
        "[iol]": false,
        "abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz": true,
        "(.)\\1.*([^\\1])\\2": true
    ]
    for (p, val) in patterns {
        let regex = try! NSRegularExpression(pattern: p, options: [])
        let matches = regex.matchesInString(s, options: [], range: NSMakeRange(0, s.characters.count))
        if matches.isEmpty == val { return false }
    }

    return true
}

func main() {
    var s = "hepxcrrq"
    let badChars: [Character] = ["i", "o", "l"]

    repeat {
        increment(&s, skip: badChars)
    } while !isGood(s)
    print("First password is: \(s)")

    repeat {
        increment(&s, skip: badChars)
    } while !isGood(s)
    print("Second password is: \(s)")
}

main()
