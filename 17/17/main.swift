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

func fill(capacity: Int, containers: [Int]) -> [Any]? {
    if containers.count == 1 {
        if containers[0] == capacity {
            return containers
        } else {
            return nil
        }
    } else {
        var a: [Any] = []
        for i in 0 ..< containers.count {
            var newContainers = containers
            let container = newContainers.removeAtIndex(i)
            let rest = fill(capacity - container, containers: newContainers)
            if rest != nil {
                a.append([container, rest] as [Any])
            }
        }
        return a
    }
}

func main() {
    let containers = getInput().componentsSeparatedByString("\n").filter({ $0 != "" }).map({ Int($0)! })
    let f = fill(25, containers: containers)
    print(f)
}

main()
