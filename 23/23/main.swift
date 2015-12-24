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

func runMachine(instructions: [String], var registers: [String:UInt]) -> [String:UInt] {
    var pc = 0
    let regex3Args = try! NSRegularExpression(pattern: "^([^ ]+) (.+), (.+)$", options: [])
    let regex2Args = try! NSRegularExpression(pattern: "^([^ ]+) (.+)$", options: [])
    repeat {
        let instruction = instructions[pc]
        var matches = regex3Args.matchesInString(instruction, options: [], range: NSMakeRange(0, instruction.characters.count))
        if matches.isEmpty {
            matches = regex2Args.matchesInString(instruction, options: [], range: NSMakeRange(0, instruction.characters.count))
        }
        let a = getMatches(instruction, matches: matches)
        switch a[0] {
        case "hlf":
            registers[a[1]] = registers[a[1]]! / 2
            pc++
        case "tpl":
            registers[a[1]] = registers[a[1]]! * 3
            pc++
        case "inc":
            registers[a[1]]!++
            pc++
        case "jmp":
            pc += Int(a[1])!
        case "jie":
            if registers[a[1]]! % 2 == 0 {
                pc += Int(a[2])!
            } else {
                pc++
            }
        case "jio":
            if registers[a[1]]! == 1 {
                pc += Int(a[2])!
            } else {
                pc++
            }
        default:
            break
        }
    } while pc > 0 && pc < instructions.count
    return registers
}

func main() {
    let instructions = getInput().componentsSeparatedByString("\n").filter({ $0 != "" })

    var reg: [String:UInt] = ["a": 0, "b": 0]
    reg = runMachine(instructions, registers: reg)
    print("With a starting as 0, b comes out as \(reg["b"]!).")

    reg = ["a": 1, "b": 0]
    reg = runMachine(instructions, registers: reg)
    print("With a starting as 1, b comes out as \(reg["b"]!).")
}

main()
