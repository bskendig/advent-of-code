//
//  Wire.swift
//  7
//
//  Created by Brian Kendig on 12/7/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

class Wire {
    enum Operation {
        case Signal
        case Identity
        case Not
        case And
        case Or
        case Xor
        case LShift
        case RShift
    }

    let name: String
    let operation: Operation
    let inputs: [String]
    var value: UInt16?

    init(name: String, operation: Operation, inputs: [String]) {
        self.name = name
        self.operation = operation
        self.inputs = inputs
        self.value = nil  // no signal
    }

    init(name: String, value: UInt16) {
        self.name = name
        self.operation = .Signal
        self.inputs = []
        self.value = value
    }
}
