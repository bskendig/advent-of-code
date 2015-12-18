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
        for (i, container) in containers.enumerate() {
            if container == capacity {
                allWorkingCombinations += [[container]]
            } else if container < capacity {
                // fill this container, then try the rest of the containers
                let restOfContainers = Array(containers[i+1 ..< containers.count])
                let newWorkingCombinations: [[Int]] = fill(capacity - container, containers: restOfContainers)
                if newWorkingCombinations.count > 0 {
                    allWorkingCombinations += newWorkingCombinations.map({ (var a: [Int]) -> [Int] in
                        a.append(container)
                        return a
                    })
                }
            }
        }
        return allWorkingCombinations
    }
}

func main() {
    let containers = getInput().componentsSeparatedByString("\n").filter({ $0 != "" }).map({ Int($0)! })

    let filledContainers = fill(150, containers: containers)
    print("There are \(filledContainers.count) different ways to fill the containers.")

    let shortestLength = filledContainers.minElement({ $0.count < $1.count })!.count
    let shortLists = filledContainers.filter({ $0.count == shortestLength })
    print("There are \(shortLists.count) ways to fill \(shortestLength) containers.")
}

main()
