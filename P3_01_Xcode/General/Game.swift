//
//  Game.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

class Game {
    
    // MARK: - Properties
    
    /// Players list.
    static var players: [Player] = []
    
    /// The round which is actually in progress.
    static var activeRound: Round?
    
    /// Check if a player is defeated and if the game can continue.
    var gameCanContinue: Bool {
        return Game.players[0].isDefeated || Game.players[1].isDefeated ? false : true
    }
    
    // MARK: - Start
    
    /// Manage game from players creation to statistics display.
    func start() {
        // check randomCreation to know if players and characters have to be created by user.
        if BACProperties.randomCreation {
            // create random players and characters
            playersCreationByBot()
            charactersCreationByBot()
        } else {
            // let user choose players names and characters
            StyleSheet.displayTitle("PLAYERS NAME")
            playersCreationByUser()
            StyleSheet.displayTitle("CHARACTERS CHOICE")
            charactersCreationByUser()
        }
        // first round creation
        Game.activeRound = Round()
        // fight
        StyleSheet.displayTitle("LET'S FIGHT")
        // iterate rounds until all characters of a player are dead
        while gameCanContinue {
            handleFight()
        }
        // end
        endGame()
    }
    
    // MARK: - Creation by User - Players
    
    /// Manage Players creation by user.
    private func playersCreationByUser() {
        // player creation [by user]
        // iterate player's creation until two players are created
        while Game.players.count < 2 {
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
        Game.players.append(Player(name: verifiedName, index: Game.players.count))
    }
    
    /// Ask player's name and returns it.
    /// - returns: If the name is correct, *returns it*; otherwise *returns nil*.
    private func askPlayerName() -> String? {
        // ask name
        let name = Ask.freeAnswer("\nWhat's the player \(Game.players.count + 1)'s name ?")
        if Game.players.count == 1 {
            if Game.players[0].name.lowercased() == name.lowercased() {
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
    
    // MARK: Characters
    
    /// Manage Characters creation by user.
    private func charactersCreationByUser() {
        // characters creation [by user]
        // iterate characters creation for each player until all characters have been created
        for index in 0...1 {
            Game.players[index].charactersCreationByUser()
        }
    }
    
    // MARK: - Fight
    
    /// Manage fight beginning and ending.
    private func handleFight() {
        StyleSheet.displaySubTitle("ROUND \(Statistics.rounds.count + 1)")
        let round = Game.returnActiveRound()
        if let chest = round.startAndReturnChest() {
            Statistics.chests.append(chest)
        }
        Statistics.rounds.append(round)
        if gameCanContinue {
            Game.activeRound = Round()
        }
    }
    
    /// Ask active round in the game.
    /// - returns: Active round.
    static func returnActiveRound() -> Round {
        guard let round = activeRound else {
            print("Fatal Error : active round returns nil.")
            exit(0)
        }
        return round
    }
    
    // MARK: - End game
    
    /// Display winner and statistics.
    private func endGame() {
        // display winner
        let index: Int
        if Game.players[0].isDefeated {
            index = 1
        } else {
            index = 0
        }
        StyleSheet.displayTitle("🏆 \(Game.players[index].name.uppercased()) WINS ! 🏆")
        StyleSheet.displayMiniTitle("CONGRATULATIONS !")
        Ask.pressEnter()
        // display statistics
        StyleSheet.displayTitle("STATISTICS")
        let statistics = Statistics()
        statistics.display()
        StyleSheet.displayTitle("THE END")
    }
    
    // MARK: Creation by Bot - Players
    
    // To avoid players and characters creation during tests, the following methods generate random players and characters.
    
    /// Manage random Players creation.
    private func playersCreationByBot() {
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
            Game.players.append(Player(name: verifiedName, index: index))
        }
    }
    
    /// Choose a name for a player and verifiy if the other player has the same.
    private func randomPlayerName() -> String? {
        let names = ["Sheldon", "Leonard", "Penny", "Howard", "Bernadette", "Raj"]
        let index = Int.random(in: 0...names.count - 1)
        if Game.players.count == 1 {
            if Game.players[0].name == names[index] {
                return nil
            }
        }
        return names[index]
    }
    
    // MARK: - Characters
    
    /// Manage random Characters creation.
    private func charactersCreationByBot() {
        // characters creation [random]
        for player in Game.players {
            player.charactersCreationByBot()
        }
    }
}
