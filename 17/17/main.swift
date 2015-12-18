//
//  main.swift
//  17
//
//  Created by Brian Kendig on 12/17/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("input", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func fill(capacity: Int, containers: [Int]) -> [[Int]] {
    if capacity <= 0 {
        return []
    }
    if containers.count == 1 {
        if containers[0] == capacity {
            return [containers]
        } else {
            return []
        }
    } else {
        var allWorkingCombinations: [[Int]] = []
        for i in 0 ..< containers.count {
            // try the subset with this container removed
            var newContainers = containers
            let container: Int = newContainers.removeAtIndex(i)

            if container == capacity {
                allWorkingCombinations += [[container]]
            } else if container < capacity {
                let rest: [[Int]] = fill(capacity - container, containers: newContainers)
                if rest.count > 0 {
                    var newA: [[Int]] = []
                    for r in rest {
                        var r2 = r
                        r2.append(container)
                        newA.append(r2)
                    }
                    allWorkingCombinations += newA
                }
            }
        }
        return allWorkingCombinations
    }
}

func main() {
    let containers = getInput().componentsSeparatedByString("\n").filter({ $0 != "" }).map({ Int($0)! })

    let f = fill(150, containers: containers)
    print(f)
    print(f.count)
}

main()
