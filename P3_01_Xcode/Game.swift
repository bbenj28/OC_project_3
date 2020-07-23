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
    
    var rounds: [Round] = [] // rounds list
    var activeRound: Round { // the round which is actually in progress
        return rounds[rounds.count - 1]
    }
    var chests: [Chest] = [] // list of generated chests during the rounds
    
    var randomCharacters: Bool = true
    
        // MARK: Methods
    func start() {
        if randomCharacters {
            players = [Player(name: "Elo", index: 0), Player(name: "Ben", index: 1)]
            Player.characters = [Warrior(name: "Arthur", weapon: Sword(firstWeapon: true, lifeStep: .fulLife)), Druid(name: "Merlin", weapon: HealthStick(firstWeapon: true, lifeStep: .fulLife)), Joker(name: "Perceval", weapon: Knife(firstWeapon: true, lifeStep: .fulLife)), Warrior(name: "Lancelot", weapon: Sword(firstWeapon: true, lifeStep: .fulLife)), Wizard(name: "Lot", weapon: PowerStick(firstWeapon: true, lifeStep: .fulLife)), Joker(name: "Dagonnet", weapon: Knife(firstWeapon: true, lifeStep: .fulLife))]
        } else {
            print("----------------------------------------")
            print("------------- PLAYERS NAME -------------")
            while players.count < 2 {
                addPlayer()
            }
            print("\n\n\n----------------------------------------")
            print("---------- CHARACTERS CHOICE -----------")
            for index in 0...1 {
                print("----------------------------------------")
                print("---> \(players[index].name)")
                while Player.characters.count < 3 * index + 3 {
                    players[index].chooseCharacter()
                }
            }
        }
        
        
        print("\n\n\n----------------------------------------")
        print("------------- LET'S FIGHT --------------")
        let round1 = Round(playingPlayer: players[0], watchingPlayer: players[1])
        self.rounds = [round1]
        while players[0].isDefeated == false && players[1].isDefeated == false {
            print("\n\n\n----------------------------------------")
            print("---> ROUND \(rounds.count)")
            if let chest = activeRound.start() {
                chests.append(chest)
            }
            newRound()
        }
        if players[0].isDefeated {
            print("\n\n\n------ \(players[1].name.uppercased()) WINS ! -----")
        }
        print("\n\n\n----------------------------------------")
        print("-------------- STATISTICS --------------")
        displayStatistics()
    }
    private func addPlayer() {
        print("Entrer le nom du joueur \(players.count + 1) :")
        let answer = readLine()
        guard let verifiedAnswer = answer else {
            print("Please choose a name.")
            return
        }
        if players.count == 1 {
            if players[0].name.lowercased() == verifiedAnswer.lowercased() {
                print("This name is already used. Please choose another.")
                return
            }
        }
        players.append(Player(name: verifiedAnswer, index: players.count))
    }

    
    func addCharacter(player: Player, character: Character) -> Bool {
        // verifying if the name of the new character is not already used by another character in characters. If already used : returns false, else add character in characters and returns true
        if characters.count > 0 {
            for registeredCharacter in characters {
                if registeredCharacter.name == character.name {
                    return false
                }
            }
        }
        //player.addCharacter(character)
        characters.append(character)
        return true
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
    
    private func displayStatistics() {
        print("\n****** rounds ******")
        print("count : \(rounds.count)")
        
        print("\n****** chests ******")
        print("count : \(chests.count)")
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
