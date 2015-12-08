//
//  main.swift
//  8
//
//  Created by Brian Kendig on 12/8/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("simple", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func replaceMultipleStrings(s: String, pattern: String, replace: (String) -> String) -> String {
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    var offset = 0 // keep track of range changes in the string due to replacements
    var sc = s  // copy the string so it's mutable

    for result in regex.matchesInString(sc, options: [], range: NSMakeRange(0, sc.characters.count)) {
        var resultRange = result.range
        resultRange.location += offset  // update it based on the offset

        let match = regex.replacementStringForResult(result, inString: sc, offset: offset, template: "$0")
        let replacement = replace(match)

        // make the replacement
        sc.replaceRange(
            sc.startIndex.advancedBy(resultRange.location)
                ..< sc.startIndex.advancedBy(resultRange.location + resultRange.length),
            with: replacement)

        // update the offset based on the replacement
        offset += (replacement.characters.count - resultRange.length)
    }
    return sc
}

func main() {
    let names = getInput().componentsSeparatedByString("\n")

    // the regexps have to be escaped twice for some reason
    // the pattern is: \[\"]|\x..

    // part 1

    var count = 0
    for name in names {
        if name.isEmpty { continue }

        var pattern = "\\\\[\\\\\\\"]|\\\\x"
        var replace = {
            (match: String) -> String in
            if match == "\\\"" { return "\\\\\\\"" }
            else if match == "\\\\" { return "\\\\\\\\" }
            else { return "\\" + match }
        }
        var s = replaceMultipleStrings(name, pattern: pattern, replace: replace)

        pattern = "^\"|\"$"
        replace = {
            (match: String) -> String in
            return ""
        }
        s = replaceMultipleStrings(s, pattern: pattern, replace: replace)

        let c = s.characters.count - name.characters.count
        count += c

        print("\(c) \(name) -> \(s)")
    }

    // part 2

    let escape = try! NSRegularExpression(pattern: "\\\\[\\\\\\\"]|\\\\x..", options: [])

    for name in names {
        if name.isEmpty { continue }
        let range = name.startIndex.advancedBy(1) ..< name.endIndex.advancedBy(-1)
        let shortenedName1 = name.substringWithRange(range)
        let shortenedName2 = escape.stringByReplacingMatchesInString(shortenedName1, options: [],
            range: NSMakeRange(0, shortenedName1.characters.count), withTemplate: "*")
        let c = name.characters.count - shortenedName2.characters.count

        count += c
    }
    print("\(count) characters in the first part")

    count = 0
    for name in names {
        if name.isEmpty { continue }

        let replace = {
            (match: String) -> String in
            if match == "\\\"" { return "\\\\\\\"" }
            else if match == "\\\\" { return "\\\\\\\\" }
            else { return "\\" + match }
        }
        let pattern = "\\\\[\\\\\\\"]|\\\\x"
        var s = replaceMultipleStrings(name, pattern: pattern, replace: replace)
//        s = replaceMultipleStrings(s, pattern: "^\"|\"$", replacements: ["\"": "\\\""])
        s = "\"\(s)\""

        let c = s.characters.count - name.characters.count
        count += c
    }
    print("\(count) characters in the second part")
}

main()
