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
    //static var rounds: [Round] = [] // rounds list
    static var activeRound: Round { // the round which is actually in progress
        return Statistics.rounds[Statistics.rounds.count - 1]
    }
    //static var chests: [Chest] = [] // list of generated chests during the rounds
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
            Game.displayTitle("PLAYERS NAME")
            userPlayersCreation()
            Game.displayTitle("CHARACTERS CHOICE")
            userCharactersCreation()
        }
        
        // first round creation
        let round1 = Round(playingPlayer: players[0], watchingPlayer: players[1])
        Statistics.rounds = [round1]
        
        // fight
        Game.displayTitle("LET'S FIGHT")
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
        let name = Game.askFreeAnswer("\nWhat's the player \(players.count + 1) name ?")
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
            Game.displaySubTitle("\(players[index].name)")
            while Player.characters.count < 3 * index + 3 {
                players[index].chooseCharacter()
            }
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
        Game.displaySubTitle("ROUND \(Statistics.rounds.count)")
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
        Game.displayTitle("🏆 \(players[index].name.uppercased()) WINS ! 🏆")
        Game.displayMiniTitle("CONGRATULATIONS !")
        Game.pressEnter()
        // display statistics
        Game.displayTitle("STATISTICS")
        Statistics.display()
        Game.displayTitle("THE END")
    }
    
    
    
        // MARK: Titles (static)
    
    static func displayTitle(_ title: String) {
        // parameters
        displaySelectedTitle(
        title: title,
        maxDash: 70,
        dash: "=")
    }
    static func displaySubTitle(_ title: String) {
        // parameters
        displaySelectedTitle(
        title: title,
        maxDash: 60,
        dash: "*")
    }
    static func displayMiniTitle(_ title: String) {
        // parameters
        displaySelectedTitle(
            title: title,
            maxDash: 50,
            dash: "-")
    }
    static private func displaySelectedTitle(title: String, maxDash: Int, dash: String) {
        var text = "\n\n\n"
        if title.count > maxDash - 10 {
            print("Fatal Error : subtitle too long.")
            exit(0)
        }
        let dashCount: Int = (maxDash - title.count - 2) / 2
        // line
        for _ in 1...dashCount {
            text += dash
        }
        text += " \(title) "
        for _ in 1...dashCount {
            text += dash
        }
        if title.count + 2 + dashCount * 2 == maxDash - 1 {
            text += dash
        }
        // display
        print(text)
    }
    static func displayStarLine() {
        let maxDash = 50
        let dash = "-"
        var text = "\n"
        // line
        for _ in 1...maxDash {
            text += dash
        }
        // display
        print(text)
    }
    
    
    
        // MARK: Readlines (static)
    
    
    
    
                // MARK: Press enter
    static func pressEnter() {
        print("PRESS ENTER")
        let _ = readLine()
    }
    
                // MARK: Ask Confirmation
    /// Ask user to confirm choices by enter Y or N.
    /// ```
    /// let confirmation = Game.askForConfirmation("Are you sure ?")
    /// ```
    /// - parameter message : Message to display before asking user an answer.
    /// - returns: True if Y was entered, False if N was entered.
    static func askForConfirmation(_ message: String) -> Bool {
        print("\(message) (Y/N)")
        var answer: Bool? = nil
        while answer == nil {
            answer = iterateConfirmation()
        }
        guard let confirmation = answer else {
            print("Fatal Error : confirmation returns nil.")
            exit(0)
        }
        return confirmation
    }
    /// Ask user to confirm choices by enter Y or N.
    /// - returns: True if Y was entered, False if N was entered, nil otherwise.
    static private func iterateConfirmation() -> Bool? {
        let answer = readLine()
        if let verifiedAnswer = answer {
            if verifiedAnswer.lowercased() == "y" {
                return true
            }
            if verifiedAnswer.lowercased() == "n" {
                return false
            }
        }
        print("Enter Y for Yes, N for No.")
        return nil
    }
    
                // MARK: Ask Number
    /// Ask user to choose a number.
    /// ```
    /// let skill = Game.askNumber(range: 1...3, message: "Choose a skill
    /// by enter a number between 1 and 3.", cancelProposition:
    /// "Enter 0 to cancel and choose another character.")
    /// ```
    /// - parameter range: Range in which user has to choose a number.
    /// - parameter message : Message to display before asking user a number.
    /// - parameter cancelProposition : Message to display to tell user cancel possibilty and its effect. Choose nil if the user can't cancel.
    /// - returns: The choosen number.
    static func askNumber(range: ClosedRange<Int>, message: String, cancelProposition: String?) -> Int {
        // range verifications and get min and max values
        guard let min = range.min() else {
            print("Fatal Error : minimum value in range returns nil.")
            exit(0)
        }
        if min <= 0 {
            print("Fatal Error : range minimum has to be superior than zero.")
            exit(0)
        }
        guard let max = range.max() else {
            print("Fatal Error : maximum value in range returns nil.")
            exit(0)
        }
        if min >= max {
            print("Fatal Error : minimum value in range has to be inferior than its superior value.")
            exit(0)
        }
        // display messages and check cancel possibility
        print(message)
        let canCancel: Bool
        if let cancelMessage = cancelProposition {
            print(cancelMessage)
            canCancel = true
        } else {
            canCancel = false
        }
        // prepare error text
        let errorText: String
        if canCancel {
            errorText = "Enter a number between \(min) and \(max), or 0 to cancel."
        } else {
            errorText = "Enter a number between \(min) and \(max)."
        }
        // ask answer
        var answer: Int? = nil
        while answer == nil {
            answer = iterateNumber(range: range, canCancel: canCancel, errorText: errorText)
        }
        guard let number = answer else {
            print("Fatal Error : number returns nil.")
            exit(0)
        }
        // return number
        return number
    }
    /// Ask user to choose a number.
    /// - parameter range: Range in which user has to choose a number.
    /// - parameter canCancel : True if the user can cancel, false otherwise.
    /// - parameter errorText : Message to display if the choice is incorrect.
    /// - returns: The choosen number. Returns nil if the choice is incorrect.
    static private func iterateNumber(range: ClosedRange<Int>, canCancel: Bool, errorText: String) -> Int? {
        let number = readLine()
        guard let existingNumber = number else {
            print(errorText)
            return nil
        }
        guard let verifiedNumber = Int(existingNumber) else {
            print(errorText)
            return nil
        }
        if verifiedNumber == 0 && canCancel {
            return 0
        }
        if range.contains(verifiedNumber) {
            return verifiedNumber
        } else {
            print(errorText)
            return nil
        }
    }
    
            // MARK: Ask free answer
    /// Ask user to choose to enter a text.
    /// ```
    /// let name = askFreeAnswer("What's your name ?")
    /// ```
    /// - parameter message : Message to display before asking user an answer.
    /// - returns: The text entered by the user.
    static func askFreeAnswer(_ message: String) -> String {
        print(message)
        var answer: String? = nil
        while answer == nil {
            answer = iterateFreeAnswer()
        }
        guard let verifiedAnswer = answer else {
            print("Fatal Error : free answer returns nil.")
            exit(0)
        }
        return verifiedAnswer
    }
    static private func iterateFreeAnswer() -> String? {
        let answer = readLine()
        guard let verifiedAnswer = answer else {
            print("Your answer is empty. Please enter a text.")
            return nil
        }
        if verifiedAnswer == "" {
            print("Your answer is empty. Please enter a text.")
            return nil
        }
        return verifiedAnswer
    }
}
