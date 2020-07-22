//
//  Game.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

// MARK: Game

class Game {
    
        // MARK: Properties
    var players: [Player] = [] // players list
    var characters: [Character] = [] // characters list
    var rounds: [Round] // rounds list
    var activeRound: Round { // the round which is actually in progress
        return rounds[rounds.count - 1]
    }
    var chests: [Chest] = [] // list of generated chests during the rounds
    
        // MARK: Init
    init(namePlayer1: String, namePlayer2: String) {
        // players creation
        let player1 = Player(name: namePlayer1, index: 0)
        let player2 = Player(name: namePlayer2, index: 1)
        players = [player1, player2]
        // first round creation, first player to play choosen by random Int
        let playingPlayerIndex = Int.random(in: 0...1)
        var watchingPlayerIndex: Int{
            if playingPlayerIndex == 0{
                return 1
            } else {
                return 0
            }
        }
        let round1 = Round(playingPlayer: players[playingPlayerIndex], watchingPlayer: players[watchingPlayerIndex])
        self.rounds = [round1]
    }
    
        // MARK: Methods
    func addCharacter(player: Player, character: Character) -> Bool {
        // verifying if the name of the new character is not already used by another character in characters. If already used : returns false, else add character in characters and returns true
        if characters.count > 0 {
            for registeredCharacter in characters {
                if registeredCharacter.name == character.name {
                    return false
                }
            }
        }
        player.addCharacter(character)
        characters.append(character)
        return true
    }
    func roundDidEndAndPlayerIsVictorious() -> Bool{
        // verifying if the last round has been ended by a player victory: returns true if there is a winner, else creates a new round and returns false
        if activeRound.victoriousPlayer {
            return true
        } else {
            newRound()
            return false
        }
    }
    private func newRound() {
        // verifying the playing player of the last round, and create a new one with the other player
        switch activeRound.playingPlayer.name {
        case players[0].name:
            rounds.append(Round(playingPlayer: players[1], watchingPlayer: players[0]))
        default:
            rounds.append(Round(playingPlayer: players[0], watchingPlayer: players[1]))
        }
    }
    func addChest(_ chest: Chest) {
        // add a chest to chests array, for statistics purpose
        chests.append(chest)
    }
}
