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

func main() {
    let names = getInput().componentsSeparatedByString("\n")

    // the regexps have to be escaped twice for some reason
    // the pattern is: \[\"]|\x..
    let escape = try! NSRegularExpression(pattern: "\\\\[\\\\\\\"]|\\\\x..", options: [])

    var count = 0
    for name in names {
        if name.isEmpty { continue }
        let range = name.startIndex.advancedBy(1) ..< name.endIndex.advancedBy(-1)
        let shortenedName1 = name.substringWithRange(range)
        let shortenedName2 = escape.stringByReplacingMatchesInString(shortenedName1, options: [],
            range: NSMakeRange(0, shortenedName1.characters.count), withTemplate: "*")
        let c = name.characters.count - shortenedName2.characters.count

//        print("\(c) \(name) -> \(shortenedName2)")
        //        print(name + " -> " + NSRegularExpression.escapedPatternForString(name))
        count += c
    }
    print(count)

    count = 0
    for name in names {
        if name.isEmpty { continue }
        var n = name
        var offset = 0 // keep track of range changes in the string due to replacements
        for result in escape.matchesInString(name, options: [], range: NSMakeRange(0, name.characters.count)) {
            var resultRange = result.range
            resultRange.location += offset  // update it based on the offset

            let match = escape.replacementStringForResult(result, inString: n, offset: offset, template: "$0")
            var replacement = "*"
            if match == "\\\"" { replacement = "\\\\\\\"" }
            else if match == "\\\\" { replacement = "\\\\\\\\" }
            else { replacement = "\\" + match }

            // make the replacement
            n.replaceRange(
                n.startIndex.advancedBy(resultRange.location)
                    ..< n.startIndex.advancedBy(resultRange.location + resultRange.length),
                with: replacement)

            // update the offset based on the replacement
            offset += (replacement.characters.count - resultRange.length)
        }
        let c = n.characters.count - name.characters.count + 4
        print("\(c) \(name) -> \(n)")
        count += c
    }
    print(count)
}

main()
