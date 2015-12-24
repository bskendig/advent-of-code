//
//  main.swift
//  23
//
//  Created by Brian Kendig on 12/23/15.
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
    let instructions = getInput().componentsSeparatedByString("\n").filter({ $0 != "" })
    var reg: [String:UInt] = ["a": 1, "b": 0]
    var pc = 0
    let regex = try! NSRegularExpression(pattern: "^([^ ]+) (.+)$", options: [])
    repeat {
        let instruction = instructions[pc]
        print(instruction)
        let a = getMatches(instruction, matches: regex.matchesInString(instruction, options: [], range: NSMakeRange(0, instruction.characters.count)))
        switch a[0] {
        case "hlf":
            reg[a[1]] = reg[a[1]]! / 2
            pc++
        case "tpl":
            reg[a[1]] = reg[a[1]]! * 3
            pc++
        case "inc":
            reg[a[1]]!++
            pc++
        case "jmp":
            pc += Int(a[1])!
        case "jie":
            let args = a[1].componentsSeparatedByString(", ")
            if reg[args[0]]! % 2 == 0 {
                pc += Int(args[1])!
            } else {
                pc++
            }
        case "jio":
            let args = a[1].componentsSeparatedByString(", ")
            if reg[args[0]]! == 1 {
                pc += Int(args[1])!
            } else {
                pc++
            }
        default:
            break
        }
    } while pc > 0 && pc < instructions.count

    print(reg["b"])
}

main()
