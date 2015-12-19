//
//  main.swift
//  18
//
//  Created by Brian Kendig on 12/18/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func getInput() -> String {
    let bundle = NSBundle.mainBundle()
    let path = bundle.pathForResource("simple", ofType: "txt")
    return try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
}

func neighbors(lights: [[Bool]], x: Int, y: Int) -> Int {
    var n = 0
    if x > 0 && y > 0 && lights[x-1][y-1] { n++ }
    if x > 0 && lights[x-1][y] { n++ }
    if x > 0 && y < lights[x].count-1 && lights[x-1][y+1] { n++ }
    if y > 0 && lights[x][y-1] { n++ }
    if y < lights[x].count-1 && lights[x][y+1] { n++ }
    if x < lights.count-1 && y > 0 && lights[x+1][y-1] { n++ }
    if x < lights.count-1 && lights[x+1][y] { n++ }
    if x < lights.count-1 && y < lights[x].count-1 && lights[x+1][y+1] { n++ }
    return n
}

func forceLightsOn(inout lights: [[Bool]]) {
    lights[0][0] = true
    lights[0][lights[0].count-1] = true
    lights[lights.count-1][0] = true
    lights[lights.count-1][lights[0].count-1] = true
}

func nextState(inout lights: [[Bool]], stuckLights: Bool = false) -> [[Bool]] {
    if stuckLights {
        forceLightsOn(&lights)
    }
//    printLights(lights)
    var nextState: [[Bool]] = []
    let width = lights[0].count
    let height = lights.count
    for i in 0 ..< height {
        var a: [Bool] = []
        for j in 0 ..< width {
            let n = neighbors(lights, x: i, y: j)
            a.append((lights[i][j] == true && (n == 2 || n == 3)) || (lights[i][j] == false && n == 3))
        }
        nextState.append(a)
    }
    return nextState
}

func printLights(lights: [[Bool]]) {
    for row in lights {
        print(row.map({ $0 ? "#" : "." }).joinWithSeparator(""))
    }
    print("")
}

func countLights(lights: [[Bool]]) -> Int {
    var count = 0
    for row in lights {
        count += row.reduce(0, combine: { $0  + ($1 ? 1 : 0) })
    }
    return count
}

func main() {
    let lines = getInput().componentsSeparatedByString("\n").filter({ $0 != "" })
    var lights: [[Bool]] = []

    for line in lines {
        var a: [Bool] = []
        for c in line.characters {
            a.append((c == "#"))
        }
        lights.append(a)
    }

    let startingPattern = lights
    let steps = 5

    for _ in 1 ... steps {
        lights = nextState(&lights)
    }
    print("\(countLights(lights)) lights are on after \(steps) steps.")
    lights = startingPattern
    printLights(lights)
    for _ in 1 ... steps {
        lights = nextState(&lights, stuckLights: true)
    }
    forceLightsOn(&lights)
    print("\(countLights(lights)) lights are on after \(steps) steps with some stuck on.")

}

main()
