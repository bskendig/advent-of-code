//
//  main.swift
//  21
//
//  Created by Brian Kendig on 12/21/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

func doIWin(myDamage: Int, myArmor: Int) -> Bool {
    let bossHP = 109, bossDamage = 8, bossArmor = 2
    let myHP = 100

    let damageToMeEachTurn = max(bossDamage - myArmor, 1)
    let damageToBossEachTurn = max(myDamage - bossArmor, 1)

    let turnsToKillMe = ceil(Float(myHP / damageToMeEachTurn))
    let turnsToKillBoss = ceil(Float(bossHP / damageToBossEachTurn))

    return turnsToKillBoss <= turnsToKillMe
}

func main() {
    let weapons: [String:(cost: Int, damage: Int, armor: Int)] = [
        "Dagger":     (  8, 4, 0),
        "Shortsword": ( 10, 5, 0),
        "Warhammer":  ( 25, 6, 0),
        "Longsword":  ( 40, 7, 0),
        "Greataxe":   ( 74, 8, 0)
    ]
    let armors: [String:(cost: Int, damage: Int, armor: Int)] = [
        "none":       (  0, 0, 0),
        "Leather":    ( 13, 0, 1),
        "Chainmail":  ( 31, 0, 2),
        "Splintmail": ( 53, 0, 3),
        "Bandedmail": ( 75, 0, 4),
        "Platemail":  (102, 0, 5)
    ]
    let rings: [String:(cost: Int, damage: Int, armor: Int)] = [
        "none1":      (  0, 0, 0),
        "none2":      (  0, 0, 0),
        "Damage +1":  ( 25, 1, 0),
        "Damage +2":  ( 50, 2, 0),
        "Damage +3":  (100, 3, 0),
        "Defense +1": ( 20, 0, 1),
        "Defense +2": ( 40, 0, 2),
        "Defense +3": ( 80, 0, 3)
    ]

    var success: [(String, Int)] = []
    var failure: [(String, Int)] = []

    for weapon in weapons {
        for armor in armors {
            for ring1 in rings {
                for ring2 in rings where ring1.0 != ring2.0 {
                    let equipment = [weapon, armor, ring1, ring2].map({ $0.0 }).joinWithSeparator(", ")
                    let cost = [weapon, armor, ring1, ring2].map({ $0.1.cost }).reduce(0, combine: +)
                    let damage = [weapon, armor, ring1, ring2].map({ $0.1.damage }).reduce(0, combine: +)
                    let protection = [weapon, armor, ring1, ring2].map({ $0.1.armor }).reduce(0, combine: +)
                    if doIWin(damage, myArmor: protection) {
                        success.append((equipment, cost))
                    } else {
                        failure.append((equipment, cost))
                    }
                }
            }
        }
    }
    print("Minimum equipment to win the fight is \(success.minElement({ $0.1 < $1.1 })!).")
    print("Maximum equipment to lose the fight is \(failure.maxElement({ $0.1 < $1.1 })!).")
}

main()
