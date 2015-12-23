//
//  main.swift
//  22
//
//  Created by Brian Kendig on 12/23/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

let bossStartingHP = 58
let bossDamage = 9

enum Spell {
    case MagicMissile, Drain, Shield, Poison, Recharge
}

func applyEffects(inout durationsRemaining: [Spell:Int], inout myArmor: Int, inout bossHP: Int, inout myMana: Int) {
    for (spell, duration) in durationsRemaining {
        switch spell {
        case .Shield:
            myArmor += 7
        case .Poison:
            bossHP -= 3
        case .Recharge:
            myMana += 101
        default:
            break
        }
        if duration == 1 {
            durationsRemaining.removeValueForKey(spell)
        } else {
            durationsRemaining[spell]!--
        }
    }
}

func oneRound(casting: Spell, var durationsRemaining: [Spell:Int], var myMana: Int, var myHP: Int, var bossHP: Int)
    -> (durationsRemaining: [Spell:Int], myMana: Int, myHP: Int, bossHP: Int)? {
        // my turn
        var myArmor = 0
        applyEffects(&durationsRemaining, myArmor: &myArmor, bossHP: &bossHP, myMana: &myMana)
        switch casting {
        case .MagicMissile:
            myMana -= 53
            bossHP -= 4
        case .Drain:
            myMana -= 73
            bossHP -= 2
            myHP += 2
        case .Shield:
            myMana -= 113
            durationsRemaining[.Shield] = 6
        case .Poison:
            myMana -= 173
            durationsRemaining[.Poison] = 6
        case .Recharge:
            myMana -= 229
            durationsRemaining[.Recharge] = 5
        }

        // boss turn
        applyEffects(&durationsRemaining, myArmor: &myArmor, bossHP: &bossHP, myMana: &myMana)
        myHP -= (9 - myArmor)

        return ([:], 0, 0, 0)
}

func main() {

}

main()
