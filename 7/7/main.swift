//
//  main.swift
//  7
//
//  Created by Brian Kendig on 12/7/15.
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

func getWires(wireInstructions: [String]) -> [String:Wire] {
    let logic: [Wire.Operation: NSRegularExpression] = [
        Wire.Operation.Signal: try! NSRegularExpression(pattern: "^(\\d+) -> (.+)$", options: []),
        Wire.Operation.And:    try! NSRegularExpression(pattern: "^(.+) AND (.+) -> (.+)$", options: []),
        Wire.Operation.Or:     try! NSRegularExpression(pattern: "^(.+) OR (.+) -> (.+)$", options: []),
        Wire.Operation.Not:    try! NSRegularExpression(pattern: "^NOT (.+) -> (.+)$", options: []),
        Wire.Operation.LShift: try! NSRegularExpression(pattern: "^(.+) LSHIFT (\\d+) -> (.+)$", options: []),
        Wire.Operation.RShift: try! NSRegularExpression(pattern: "^(.+) RSHIFT (\\d+) -> (.+)$", options: [])
    ]
    var wires: [String:Wire] = [:]

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
                print("Adding " + wireName + ".")
                wires[wireName] = wire
            }
        }
    }
    return wires
}

func eval(wireName: String, wires: [String:Wire]) -> UInt16 {
    print(wireName)

    let num = UInt16(wireName)
    if num != nil { return num! }

    let wire = wires[wireName]!
    if wire.operation == Wire.Operation.Signal {
        return wire.value!
    } else {
        switch wire.operation {
        case Wire.Operation.Not:
            let foo: UInt16? = eval(wire.inputs[0], wires: wires)
            wire.value = UInt16(bitPattern: ~Int16(foo!))
        case Wire.Operation.And:
            wire.value = eval(wire.inputs[0], wires: wires) & eval(wire.inputs[1], wires: wires)
        case Wire.Operation.Or:
            wire.value = eval(wire.inputs[0], wires: wires) | eval(wire.inputs[1], wires: wires)
        case Wire.Operation.Xor:
            wire.value = eval(wire.inputs[0], wires: wires) ^ eval(wire.inputs[1], wires: wires)
        case Wire.Operation.LShift:
            wire.value = UInt16(Int16(eval(wire.inputs[0], wires: wires)) << Int16(wire.inputs[1])!)
        case Wire.Operation.RShift:
            wire.value = UInt16(Int32(eval(wire.inputs[0], wires: wires)) >> Int32(wire.inputs[1])!)
        default:
            break
        }
    }

    return wire.value!
}

func main() {
    let wireInstructions = getInput().componentsSeparatedByString("\n")
    let wires = getWires(wireInstructions)

    print(eval("a", wires: wires))
}

main()
