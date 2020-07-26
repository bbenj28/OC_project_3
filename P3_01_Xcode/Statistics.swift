//
//  Statistics.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 25/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation
// MARK: Statistics
class Statistics {
    
    
    // MARK: Properties
    static var rounds: [Round] = []
    static var chests: [Chest] = []
    
    // MARK: Display
    /// Display statistics.
    static func display() {
        roundStatistics()
        chestsStatistics()
        charactersStatistics()
    }
    
    /// Display rounds statistics.
    static private func roundStatistics() {
        // rounds
        StyleSheet.displayMiniTitle("rounds")
        print("total : \(rounds.count)")
        // count rounds played by each player, types of characters and types of skill used during the rounds
        var playedByPlayer: [String:Int] = [Game.players[0].name : 0, Game.players[1].name : 0]
        var usedCharactersType: [CharacterType:Int] = [.warrior : 0, .wizard : 0, .druid : 0, .joker : 0]
        var usedSkillsType : [SkillsType:Int] = [.attack : 0, .diversion : 0, .heal : 0, .multiAttack : 0, .multiHeal : 0]
        for round in rounds {
            if let value = playedByPlayer[round.playingPlayer.name] {
                playedByPlayer[round.playingPlayer.name] = value + 1
            }
            if let value = usedCharactersType[round.verifyChoosenCharacter().type] {
                usedCharactersType[round.verifyChoosenCharacter().type] = value + 1
            }
            if let value = usedSkillsType[round.verifyChoosenSkill()] {
                usedSkillsType[round.verifyChoosenSkill()] = value + 1
            }
        }
        // return counts
        for (key, value) in playedByPlayer {
            print("rounds played by \(key) : \(value)")
        }
        print("rounds played with a :")
        for (key, value) in usedCharactersType {
            print("- \(key) : \(value)")
        }
        print("round's used skill :")
        for (key, value) in usedSkillsType {
            print("- \(key) : \(value)")
        }
        // end
        Ask.pressEnter()
        StyleSheet.displayStarLine()
    }
    
    /// Display chests statistics.
    static func chestsStatistics() {
        // chests
        StyleSheet.displayMiniTitle("chests")
        // total
        print("total : \(chests.count)")
        // total for each player
        for player in Game.players {
            print("\n > for \(player.name)")
            // accepted chests count
            var accepted: Int = 0
            var total: Int = 0
            for chest in chests {
                if chest.player.name == player.name {
                    total += 1
                    guard let isAccepted = chest.isAccepted else {
                        print("Fatal Error : Chest without acceptation's answer.")
                        exit(0)
                    }
                    if isAccepted {
                        accepted += 1
                    }
                }
            }
            print("total : \(total)")
            print("accepted : \(accepted)")
        }
        // end
        Ask.pressEnter()
        StyleSheet.displayStarLine()
    }
    
    /// Display characters statistics.
    static private func charactersStatistics() {
        // characters title
        StyleSheet.displayMiniTitle("characters")
        // HP of each characters
        StyleSheet.displayMiniTitle("HP")
        for character in Player.characters {
            print("\(character.name) : \(character.healthPoints)")
        }
        Ask.pressEnter()
        // strength of each characters
        StyleSheet.displayMiniTitle("Strength")
        for character in Player.characters {
            print("\(character.name) : \(character.strength)")
        }
        Ask.pressEnter()
        // sustaines injuries by each characters
        StyleSheet.displayMiniTitle("Injuries")
        for character in Player.characters {
            print("\(character.name) : \(character.injuriesPoints)")
        }
        Ask.pressEnter()
        // received healthcares by each characters
        StyleSheet.displayMiniTitle("Healthcares")
        for character in Player.characters {
            print("\(character.name) : \(character.healPoints)")
        }
        // End
        Ask.pressEnter()
        StyleSheet.displayStarLine()
    }
}
