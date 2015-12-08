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
    let path = bundle.pathForResource("input", ofType: "txt")
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

    // part 1

    var count = 0
    for name in names {
        if name.isEmpty { continue }

        // the regexps have to be escaped twice for some reason
        // the basic pattern is: \[\"]|\x..
        var pattern = "\\\\[\\\\\\\"]|\\\\x.."
        var replace = {
            (match: String) -> String in
            if match == "\\\"" { return "\"" }
            else if match == "\\\\" { return "\\" }
            else {
                let char = match.substringWithRange(Range<String.Index>(start: match.startIndex.advancedBy(2), end: match.endIndex))
                let num = Int(strtoul(char, nil, 16))
                return String(UnicodeScalar(num))
            }
        }
        var s = replaceMultipleStrings(name, pattern: pattern, replace: replace)

        pattern = "^\"|\"$"
        replace = {
            (match: String) -> String in
            return ""
        }
        s = replaceMultipleStrings(s, pattern: pattern, replace: replace)

        let c = name.characters.count - s.characters.count
        count += c
    }
    print("\(count) characters in the first part")

    // part 2

    count = 0
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
            return "\\\""
        }
        s = replaceMultipleStrings(s, pattern: "^\"|\"$", replace: replace)

        s = "\"\(s)\""

        let c = s.characters.count - name.characters.count
        count += c
    }
    print("\(count) characters in the second part")
}

main()
