//
//  main.swift
//  25
//
//  Created by Brian Kendig on 12/26/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func main() {
    // "To continue, please consult the code grid in the manual.  Enter the code at row 3010, column 3019."

    let row = 3010, col = 3019
    let diagonal = row + col - 1
    let n = (diagonal - 1) * diagonal / 2 + col

    var code = 20151125
    for _ in 2 ... n {
        code = (code * 252533) % 33554393
    }
    print("The code at row \(row), column \(col) is \(code).")
}

main()
