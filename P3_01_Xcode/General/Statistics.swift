//
//  Statistics.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 25/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation

class Statistics {
    
    // MARK: - Properties
    
    /// Played rounds during the game.
    static var rounds: [Round] = []
    
    /// Generated chests during the game.
    static var chests: [Chest] = []
    
    // MARK: - Display
    
    /// Display statistics.
    func display() {
        roundStatistics()
        chestsStatistics()
        charactersStatistics()
    }
    
    /// Display rounds statistics.
    private func roundStatistics() {
        StyleSheet.displayMiniTitle("rounds")
        // total
        print("total : \(Statistics.rounds.count)")
        // count rounds played by each player, types of characters and types of skill used during the rounds
        var playedByPlayer: [String:Int] = [Game.players[0].name : 0, Game.players[1].name : 0]
        var usedCharactersType: [CharacterType:Int] = [.warrior : 0, .wizard : 0, .druid : 0, .joker : 0]
        var usedSkillsType : [Skill:Int] = [.attack : 0, .diversion : 0, .heal : 0, .multiAttack : 0, .multiHeal : 0]
        for round in Statistics.rounds {
            if let value = playedByPlayer[round.playingPlayer.name] {
                playedByPlayer[round.playingPlayer.name] = value + 1
            }
            if let value = usedCharactersType[round.existingChoosenCharacter().type] {
                usedCharactersType[round.existingChoosenCharacter().type] = value + 1
            }
            if let value = usedSkillsType[round.existingChoosenSkill()] {
                usedSkillsType[round.existingChoosenSkill()] = value + 1
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
        StyleSheet.displayDashLine()
    }
    
    /// Display chests statistics.
    private func chestsStatistics() {
        StyleSheet.displayMiniTitle("chests")
        // total
        print("total : \(Statistics.chests.count)")
        // total for each player
        for player in Game.players {
            print("\n > for \(player.name)")
            // accepted chests count
            var accepted: Int = 0
            var total: Int = 0
            for chest in Statistics.chests {
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
        StyleSheet.displayDashLine()
    }
    
    /// Display characters statistics.
    private func charactersStatistics() {
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
        // sustained injuries by each characters
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
        StyleSheet.displayDashLine()
    }
}
