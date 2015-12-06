//
//  main.swift
//  5
//
//  Created by Brian Kendig on 12/5/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("input", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func main() {
    let words = getInput().componentsSeparatedByString("\n")
    var count = 0

    for word in words {

        // It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
        // It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
        // It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).

        if (word.rangeOfString("ab|cd|pq|xy", options: .RegularExpressionSearch) != nil) {
            continue;
        }
        if (word.rangeOfString("[aeiou].*[aeiou].*[aeiou]", options: .RegularExpressionSearch) != nil)
                && (word.rangeOfString("(.)\\1", options: .RegularExpressionSearch) != nil) {
            count++
        }
    }
    print(String(format: "%d nice strings with the first model", count))

    count = 0
    for word in words {

        // It contains a pair of any two letters that appears at least twice in the string without overlapping,
        //   like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
        // It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.

        if (word.rangeOfString("(..).*\\1", options: .RegularExpressionSearch) != nil)
                && (word.rangeOfString("(.).\\1", options: .RegularExpressionSearch) != nil) {
            count++
        }
    }
    print(String(format: "%d nice strings with the second model", count))
}

main()
