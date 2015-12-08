//
//  main.swift
//  7
//
//  Created by Brian Kendig on 12/7/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

var wires: [String:Wire] = [:]

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

func getWires(wireInstructions: [String]) -> [String:Wire] {
    let logic: [Wire.Operation: NSRegularExpression] = [
        Wire.Operation.Signal:   try! NSRegularExpression(pattern: "^(\\d+) -> (.+)$", options: []),
        Wire.Operation.Identity: try! NSRegularExpression(pattern: "^([^ ]+) -> (.+)$", options: []),
        Wire.Operation.Not:      try! NSRegularExpression(pattern: "^NOT (.+) -> (.+)$", options: []),
        Wire.Operation.And:      try! NSRegularExpression(pattern: "^(.+) AND (.+) -> (.+)$", options: []),
        Wire.Operation.Or:       try! NSRegularExpression(pattern: "^(.+) OR (.+) -> (.+)$", options: []),
        Wire.Operation.Xor:      try! NSRegularExpression(pattern: "^(.+) XOR (.+) -> (.+)$", options: []),
        Wire.Operation.LShift:   try! NSRegularExpression(pattern: "^(.+) LSHIFT (.+) -> (.+)$", options: []),
        Wire.Operation.RShift:   try! NSRegularExpression(pattern: "^(.+) RSHIFT (.+) -> (.+)$", options: [])
    ]

    for wireInstruction in wireInstructions {
        var matches: [NSTextCheckingResult]

        for (operation, regex) in logic {
            matches = regex.matchesInString(wireInstruction, options: [],
                range: NSMakeRange(0, wireInstruction.characters.count))
            if !matches.isEmpty {
                var a = getMatches(wireInstruction, matches: matches)
                let wireName = a.removeLast()
                let wire: Wire
                wire = (operation == Wire.Operation.Signal) ? Wire(name: wireName, value: UInt16(a[0])!)
                    : Wire(name: wireName, operation: operation, inputs: a)
                wires[wireName] = wire
            }
        }
    }
    return wires
}

func eval(wireName: String) -> UInt16 {

    let num = UInt16(wireName)
    if num != nil { return num! }

    let wire = wires[wireName]!
    if wire.value != nil { return wire.value! }

    if wire.operation == Wire.Operation.Signal {
        return wire.value!
    } else {
        switch wire.operation {
        case Wire.Operation.Identity:
            wire.value = eval(wire.inputs[0])
        case Wire.Operation.Not:
            wire.value = ~eval(wire.inputs[0])
        case Wire.Operation.And:
            wire.value = eval(wire.inputs[0]) & eval(wire.inputs[1])
        case Wire.Operation.Or:
            wire.value = eval(wire.inputs[0]) | eval(wire.inputs[1])
        case Wire.Operation.Xor:
            wire.value = eval(wire.inputs[0]) ^ eval(wire.inputs[1])
        case Wire.Operation.LShift:
            wire.value = eval(wire.inputs[0]) << UInt16(wire.inputs[1])!
        case Wire.Operation.RShift:
            wire.value = eval(wire.inputs[0]) >> UInt16(wire.inputs[1])!
        default:
            break
        }
    }

    return wire.value!
}

func clearWires() {
    for wire in wires.values {
        if wire.operation != Wire.Operation.Signal {
            wire.value = nil
        }
    }
}

func main() {
    let wireInstructions = getInput().componentsSeparatedByString("\n")
    wires = getWires(wireInstructions)

    var a = eval("a")
    print("Wire a has signal \(a)")

    clearWires()

    wires["b"] = Wire(name: "b", value: a)
    a = eval("a")
    print ("Wire a now has signal \(a)")
}

main()
