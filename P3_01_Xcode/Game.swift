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
    static var players: [Player] = [] // players list
    static var activeRound: Round { // the round which is actually in progress
        return Statistics.rounds[Statistics.rounds.count - 1]
    }
    static var gameCanContinue: Bool {
        return players[0].isDefeated || players[1].isDefeated ? false : true
    }
    static var randomCreation: Bool = true // true for creating random players and characters
    
        // MARK: Start
    /// Manage game from players creation to statistics display.
    static func start() {
        // check randomCreation to know if players and characters have to be created by user.
        if randomCreation {
            // create random players and characters
            randomPlayersCreation()
            randomCharactersCreation()
        } else {
            // let user choose players names and characters
            StyleSheet.displayTitle("PLAYERS NAME")
            userPlayersCreation()
            StyleSheet.displayTitle("CHARACTERS CHOICE")
            userCharactersCreation()
        }
        
        // first round creation
        let round1 = Round(playingPlayer: players[0], watchingPlayer: players[1])
        Statistics.rounds = [round1]
        
        // fight
        StyleSheet.displayTitle("LET'S FIGHT")
        // iterate rounds until all characters of a player are dead
        while gameCanContinue {
            handleFight()
        }
        
        // end
        endGame()
    }
        // MARK: User's creation
    /// Manage Players creation by user.
    static private func userPlayersCreation() {
        // player creation [by user]
        // iterate player's creation until two players are created
        while players.count < 2 {
            addPlayer()
        }
    }
    /// Ask player's name and creates it.
    static private func addPlayer() {
        // ask name
        var name: String? = nil
        while name == nil {
            name = askPlayerName()
        }
        guard let verifiedName = name else {
            print("Fatal Error : player's name returns nil.")
            exit(0)
        }
        // create player
        players.append(Player(name: verifiedName, index: players.count))
    }
    /// Ask player's name and returns it.
    /// - returns: If the name is correct, returns it; otherwise returns nil.
    static private func askPlayerName() -> String? {
        // ask name
        let name = Ask.freeAnswer("\nWhat's the player \(players.count + 1) name ?")
        if players.count == 1 {
            if players[0].name.lowercased() == name.lowercased() {
                print("This name is already used. Please choose another.")
                return nil
            }
        }
        if name.count > 30 {
            print("Please enter a shorter name.")
            return nil
        }
        // return name
        return name
    }
    /// Manage Characters creation by user.
    static private func userCharactersCreation() {
        // characters creation [by user]
        // iterate characters creation for each player until all characters have been created
        for index in 0...1 {
            players[index].userCharactersCreation()
        }
    }

        // MARK: Random creation
    /// Manage random Players creation.
    static private func randomPlayersCreation() {
        // players creation [random]
        for index in 0...1 {
            var name: String? = nil
            while name == nil {
                name = randomPlayerName()
            }
            guard let verifiedName = name else {
                print("Fatal Error : random player's name returns nil.")
                exit(0)
            }
            players.append(Player(name: verifiedName, index: index))
        }
    }
    /// Choose a name for a player and verifiy if the other player has the same.
    static private func randomPlayerName() -> String? {
        let names = ["Sheldon", "Leonard", "Penny", "Howard", "Bernadette", "Raj"]
        let index = Int.random(in: 0...names.count - 1)
        if players.count == 1 {
            if players[0].name == names[index] {
                return nil
            }
        }
        return names[index]
    }
    /// Manage random Characters creation.
    static private func randomCharactersCreation() {
        // characters creation [random]
        Player.randomCharactersCreation()
    }
    
    
    
        // MARK: Fight
    /// Manage fight beginning and ending.
    static private func handleFight() {
        StyleSheet.displaySubTitle("ROUND \(Statistics.rounds.count)")
        if let chest = activeRound.start() {
            Statistics.chests.append(chest)
        }
        if gameCanContinue {
            newRound()
        }
    }
    /// Create a new round in rounds by changing playing player.
    static private func newRound() {
        // verifying the playing player of the last round, and create a new one with the other player
        switch activeRound.playingPlayer.name {
        case players[0].name:
            Statistics.rounds.append(Round(playingPlayer: players[1], watchingPlayer: players[0]))
        default:
            Statistics.rounds.append(Round(playingPlayer: players[0], watchingPlayer: players[1]))
        }
    }
    
        // MARK: End game
    /// Display winner and statistics.
    static private func endGame() {
        // display winner
        let index: Int
        if players[0].isDefeated {
            index = 1
        } else {
            index = 0
        }
        StyleSheet.displayTitle("🏆 \(players[index].name.uppercased()) WINS ! 🏆")
        StyleSheet.displayMiniTitle("CONGRATULATIONS !")
        Ask.pressEnter()
        // display statistics
        StyleSheet.displayTitle("STATISTICS")
        Statistics.display()
        StyleSheet.displayTitle("THE END")
    }
}
