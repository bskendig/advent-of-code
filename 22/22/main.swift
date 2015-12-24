//
//  main.swift
//  22
//
//  Created by Brian Kendig on 12/23/15.
//  Copyright © 2015 Brian Kendig. All rights reserved.
//

import Foundation

enum Spell: Int {
    case MagicMissile, Drain, Shield, Poison, Recharge
//    static let count: Int = {
//        var max: Int = 0
//        while let _ = Spell(rawValue: max) { max += 1 }
//        return max
//    }()
}

let spellCost: [Spell:Int] = [
    .MagicMissile: 53,
    .Drain: 73,
    .Shield: 113,
    .Poison: 173,
    .Recharge: 229
]

struct GameState {
    var spellDurationsRemaining: [Spell:Int]
    var myHP: Int
    var myMana: Int
    var bossHP: Int
    var bossDamage: Int
}

func applyEffects(inout gameState: GameState, inout myArmor: Int) {
    for (spell, duration) in gameState.spellDurationsRemaining {
        switch spell {
        case .Shield:
            myArmor = 7
            print("Shield sets armor to 7.")
        case .Poison:
            gameState.bossHP -= 3
            print("Poison deals 3 damage.")
        case .Recharge:
            gameState.myMana += 101
            print("Recharge provides 101 mana.")
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

func oneRound(casting: Spell, var gameState: GameState) -> GameState {

    // player turn
    print("-- Player turn --")
    print("Player has \(gameState.myHP) hit points, \(gameState.myMana) mana")
    print("Boss has \(gameState.bossHP) hit points")
    var myArmor = 0
    applyEffects(&gameState, myArmor: &myArmor)
    if gameState.bossHP <= 0 {
        print("Boss is dead.")
        return gameState
    }
    gameState.myMana -= spellCost[casting]!
    switch casting {
    case .MagicMissile:
        gameState.bossHP -= 4
        print("Player casts Magic Missile, dealing 4 damage.")
    case .Drain:
        gameState.bossHP -= 2
        gameState.myHP += 2
        print("Player casts Drain, dealing 2 damage, and healing 2 hit points.")
    case .Shield:
        gameState.spellDurationsRemaining[.Shield] = 6
        print("Player casts Shield, increasing armor by 7.")
    case .Poison:
        gameState.spellDurationsRemaining[.Poison] = 6
        print("Player casts Poison.")
    case .Recharge:
        gameState.spellDurationsRemaining[.Recharge] = 5
        print("Player casts Recharge.")
    }
    if gameState.bossHP <= 0 {
        print("Boss is dead.")
        return gameState
    }
    print("")

    print("-- Boss turn --")
    print("Player has \(gameState.myHP) hit points, \(gameState.myMana) mana")
    print("Boss has \(gameState.bossHP) hit points")
    applyEffects(&gameState, myArmor: &myArmor)
    if gameState.bossHP <= 0 {
        print("Boss is dead.")
        return gameState
    }
    let damage = gameState.bossDamage - myArmor
    gameState.myHP -= damage
    print("Boss attacks for \(damage) damage!")
    if gameState.myHP <= 0 {
        print("Player is dead.")
        return gameState
    }
    print("")

    return gameState
}

func lowestManaFromThisState(gameState: GameState) -> Int {
//    if gameState.bossHP <= 0 {
//
//    } else if gameState.myHP <= 0 {
//
//    }
    var manaUsage: [Spell:Int] = [:]
    for spell: Spell in [.MagicMissile, .Drain, .Shield, .Poison, .Recharge] {
        if spellCost[spell] > gameState.myMana {
            continue
        }
        let newGameState = oneRound(spell, gameState: gameState)
        if newGameState.bossHP <= 0 {
            manaUsage[spell] = spellCost[spell]
        } else if newGameState.myHP > 0 {
            manaUsage[spell] = spellCost[spell]! + lowestManaFromThisState(newGameState)
        }
    }
    if manaUsage.count == 0 {
        return 99999
    }
    let bestSpellToUse = manaUsage.minElement({ $0.1 < $1.1 })
    // bestSpellToUse.0 is the spell
    return bestSpellToUse!.1
}

func main() {
//    let bossStartingHP = 58
//    let bossDamage = 9
//    let myStartingHP = 50
//    let myStartingMana = 500

    let bossStartingHP = 14
    let bossDamage = 8
    let myStartingHP = 10
    let myStartingMana = 250

    // we have a starting point: my hp and mana, boss hp, spell durations
    // for each possible spell we can cast from here:
    //   get a list of all possible outcomes

    var gameState = GameState(spellDurationsRemaining: [:], myHP: myStartingHP, myMana: myStartingMana, bossHP: bossStartingHP, bossDamage: bossDamage)

    print(lowestManaFromThisState(gameState))


//    for spell in [Spell.Recharge, Spell.Shield, Spell.Drain, Spell.Poison, Spell.MagicMissile] {
//        gameState = oneRound(spell, gameState: gameState)
//        print(gameState)
//    }

    for _ in 1 ... 500 {

    }


}

main()
