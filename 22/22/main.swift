//
//  main.swift
//  22
//
//  Created by Brian Kendig on 12/23/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

enum Spell {
    case MagicMissile, Drain, Shield, Poison, Recharge
}

struct GameState {
    var spellDurationsRemaining: [Spell:Int]
    var myHP: Int
    var myMana: Int
    var bossHP: Int
}

let bossStartingHP = 58
let bossDamage = 9
let myStartingHP = 50
let myStartingMana = 500

func applyEffects(inout gameState: GameState, inout myArmor: Int) {
    for (spell, duration) in gameState.spellDurationsRemaining {
        switch spell {
        case .Shield:
            myArmor += 7
        case .Poison:
            gameState.bossHP -= 3
        case .Recharge:
            gameState.myMana += 101
        default:
            break
        }
        if duration == 1 {
            gameState.spellDurationsRemaining.removeValueForKey(spell)
        } else {
            gameState.spellDurationsRemaining[spell]!--
        }
    }
}

func oneRound(casting: Spell, var gameState: GameState) -> GameState? {

        // player turn
//        print("-- Player turn --")
//        print("Player has \(myHP) hit points, \(myMana) mana")
        var myArmor = 0
        applyEffects(&gameState, myArmor: &myArmor)
        switch casting {
        case .MagicMissile:
            gameState.myMana -= 53
            gameState.bossHP -= 4
        case .Drain:
            gameState.myMana -= 73
            gameState.bossHP -= 2
            gameState.myHP += 2
        case .Shield:
            gameState.myMana -= 113
            gameState.spellDurationsRemaining[.Shield] = 6
        case .Poison:
            gameState.myMana -= 173
            gameState.spellDurationsRemaining[.Poison] = 6
        case .Recharge:
            gameState.myMana -= 229
            gameState.spellDurationsRemaining[.Recharge] = 5
        }

        // boss turn
        applyEffects(&gameState, myArmor: &myArmor)
        gameState.myHP -= (9 - myArmor)

        return gameState
}

func main() {

    // we have a starting point: my hp and mana, boss hp, spell durations
    // for each possible spell we can cast from here:
    //   get a list of all possible outcomes

}

main()
