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
    var rounds: [Round] = [] // rounds list
    var activeRound: Round { // the round which is actually in progress
        return rounds[rounds.count - 1]
    }
    var chests: [Chest] = [] // list of generated chests during the rounds
    var gameCanContinue: Bool {
        return players[0].isDefeated || players[1].isDefeated ? false : true
    }
    var randomCreation: Bool = true // true for creating random players and characters
    
        // MARK: Start
    /// Manage game from players creation to statistics display.
    func start() {
        // check randomCreation to know if players and characters have to be created by user.
        if randomCreation {
            // create random players and characters
            randomPlayersCreation()
            randomCharactersCreation()
        } else {
            // let user choose players names and characters
            userPlayersCreation()
            userCharactersCreation()
        }
        
        // first round creation
        let round1 = Round(playingPlayer: players[0], watchingPlayer: players[1])
        self.rounds = [round1]
        
        // fight
        
        print("\n\n\n----------------------------------------")
        print("------------- LET'S FIGHT --------------")
        // iterate rounds until all characters of a player are dead
        while gameCanContinue {
            handleFight()
        }
        
        // end
        endGame()
    }
    // MARK: User's creation
    /// Manage Players creation by user.
    private func userPlayersCreation() {
        // player creation [by user]
        print("----------------------------------------")
        print("------------- PLAYERS NAME -------------")
        // iterate player's creation until two players are created
        while players.count < 2 {
            addPlayer()
        }
    }
    /// Ask player's name and creates it.
    private func addPlayer() {
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
    private func askPlayerName() -> String? {
        // ask name
        print("Entrer le nom du joueur \(players.count + 1) :")
        let answer = readLine()
        // verify if name is not nil, not empty and not already used
        guard let verifiedAnswer = answer else {
            print("Please choose a name.")
            return nil
        }
        if verifiedAnswer == "" {
            print("Please choose a name.")
            return nil
        }
        if players.count == 1 {
            if players[0].name.lowercased() == verifiedAnswer.lowercased() {
                print("This name is already used. Please choose another.")
                return nil
            }
        }
        // return name
        return verifiedAnswer
    }
    /// Manage Characters creation by user.
    private func userCharactersCreation() {
        // characters creation [by user]
        print("\n\n\n----------------------------------------")
        print("---------- CHARACTERS CHOICE -----------")
        // iterate characters creation for each player until all characters have been created
        for index in 0...1 {
            print("----------------------------------------")
            print("---> \(players[index].name)")
            while Player.characters.count < 3 * index + 3 {
                players[index].chooseCharacter()
            }
        }
    }
    // MARK: Random creation
    /// Manage random Players creation.
    private func randomPlayersCreation() {
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
    private func randomPlayerName() -> String? {
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
    private func randomCharactersCreation() {
        // characters creation [random]
        Player.randomCharactersCreation()
    }
    
    
    
    // MARK: Fight
    /// Manage fight beginning and ending.
    private func handleFight() {
        print("\n\n\n----------------------------------------")
        print("---> ROUND \(rounds.count)")
        if let chest = activeRound.start() {
            chests.append(chest)
        }
        if gameCanContinue {
            newRound()
        }
    }
    /// Create a new round in rounds by changing playing player.
    private func newRound() {
        // verifying the playing player of the last round, and create a new one with the other player
        switch activeRound.playingPlayer.name {
        case players[0].name:
            rounds.append(Round(playingPlayer: players[1], watchingPlayer: players[0]))
        default:
            rounds.append(Round(playingPlayer: players[0], watchingPlayer: players[1]))
        }
    }
    
    // MARK: End game
    /// Display winner and statistics.
    private func endGame() {
        // display winner
        if players[0].isDefeated {
            print("\n\n\n------ 🏆 \(players[1].name.uppercased()) WINS ! 🏆 -----")
        } else {
            print("\n\n\n------ 🏆 \(players[0].name.uppercased()) WINS ! 🏆 -----")
        }
        // display statistics
        print("\n\n\n----------------------------------------")
        print("-------------- STATISTICS --------------")
        displayStatistics()
    }
    /// Display statistics.
    private func displayStatistics() {
        // rounds
        print("\n****** rounds ******")
        print("count : \(rounds.count)")
        
        // chests
        print("\n****** chests ******")
        // total count
        print("count : \(chests.count)")
        // accepted chests count
        var accepted: Int = 0
        for chest in chests {
            guard let isAccepted = chest.isAccepted else {
                print("Fatal Error : Chest without acceptation's answer.")
                exit(0)
            }
            if isAccepted {
                accepted += 1
            }
        }
        print("accepted : \(accepted)")
        
        // characters
        print("\n****** characters ******")
        
        print("\n****** HP ******")
        for character in Player.characters {
            print("\(character.name) : \(character.healthPoints)")
        }
        
        print("\n****** Strength ******")
        for character in Player.characters {
            print("\(character.name) : \(character.strength)")
        }
        
        print("\n****** Injuries ******")
        for character in Player.characters {
            print("\(character.name) : \(character.injuriesPoints)")
        }
        
        print("\n****** Healthcares ******")
        for character in Player.characters {
            print("\(character.name) : \(character.healPoints)")
        }
        
    }

}
