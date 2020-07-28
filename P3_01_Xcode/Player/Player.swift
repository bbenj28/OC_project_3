//
//  Player.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

class Player {
    
    
    
        // MARK: Properties
    
    
    
    // all characters
    static var characters: [Character] = [] // list of players characters
    
    // specific player's properties
    let name: String // player's name choosen in the home view
    var characters: [Character] { // characters of the player in Player.characters
        return [Player.characters[3 * index], Player.characters[3 * index + 1], Player.characters[3 * index + 2]]
    }
    let index: Int // index of the player in Game.players
    var isDefeated: Bool { // returns true if all characters are dead
        return characters[0].isDead && characters[1].isDead && characters[2].isDead
    }
    var HPSituation: Int { // returns HP / HPmax of characters
        var maxHP: Double = 0
        var HP: Double = 0
        for index in self.index * 3...self.index * 3 + 2 {
            maxHP += Double(Player.characters[index].type.maxHealthPoints())
            HP += Double(Player.characters[index].healthPoints)
        }
        return Int(HP / maxHP * 100)
    }
    
    
    
        // MARK: Init
    
    
    
    init(name: String, index: Int) {
        self.name = name
        self.index = index
    }
    
    
        // MARK: Team creation
    
    
    
                // MARK: Name verification
    
    
    
    /// Verify if the choosen name is already taken by another character.
    /// - parameter name: Name to verify.
    /// - returns: *false* if the name is available, *true* otherwise.
    private func isTakenName(_ name: String) -> Bool {
        if Player.characters.count > 0 {
            for character in Player.characters {
                if character.name.lowercased() == name.lowercased() {
                    return true
                }
            }
        }
        return false
    }
    
    
                // MARK: By Bot
    
    
    
    /// Manage random characters creation.
    func charactersCreationByBot() {
        // characters creation [random]
        while Player.characters.count < 6 {
            Player.characters.append(randomSingleCharacter())
        }
    }
    
    /// Choose name and type of a character and returns it.
    /// - returns: Created character.
    private func randomSingleCharacter() -> Character {
        // choose name
        var name: String? = nil
        while name == nil {
            name = randomName()
        }
        guard let verifiedName = name else {
            print("Fatal Error : random character's name returns nil.")
            exit(0)
        }
        // choose type
        let typeIndex = Int.random(in: 0...3)
        let types: [CharacterType] = [.warrior, .wizard, .druid, .joker]
        return Character(name: verifiedName, type: types[typeIndex])
    }
    
    /// Choose the character's name in a list by drawing a random number.
    /// - returns: If the name is already used by another character, returns *nil*; otherwise returns the name.
    private func randomName() -> String? {
        // names list
        let names = ["Arthur", "Guenièvre", "Merlin", "Léodagan", "Séli", "Bohort", "Perceval", "Caradoc", "Mevanwi", "Calogrenan", "Lancelot", "Lot", "Dagonnet", "Yvain", "Gauvain", "Galcin", "Angarade", "La Dame du Lac"]
        // random number
        let index = Int.random(in: 0...names.count - 1)
        // check if the name is already used by another character
        if isTakenName(names[index]) {
            return nil
        }
        // returns it
        return names[index]
    }
    
    
    
                // MARK: By User
    
    
    /// Let user choose characters.
    func charactersCreationByUser() {
        // player's name
        StyleSheet.displaySubTitle("\(name)")
        // iterate characters creation until all characters have been created
        var confirmation: Bool = false
        while confirmation == false {
            while Player.characters.count < 3 * index + 3 {
                chooseCharacter()
            }
            if isTeamConfirmed() {
                print("Your team has been created.")
                StyleSheet.displayDashLine()
                confirmation = true
            } else {
                print("Your choices have been canceled. Please, choose others characters.")
                StyleSheet.displayDashLine()
                removeCharacters()
            }
        }
    }
    
    /// Team is created. Ask confirmation.
    /// - returns: *true* if user has confirmed the team, *false* otherwise.
    private func isTeamConfirmed() -> Bool {
        StyleSheet.displayMiniTitle("Here's your team")
        for index in 0...2 {
            let info = characters[index].displayInformations(full: false, evenDead: false)
            guard let verifiedInfo = info else {
                print("Fatal Error : character's informations returns nil.")
                exit(0)
            }
            print(verifiedInfo)
        }
        return Ask.confirmation("Do you confirm ?")
    }
    
    /// Let user choose a character and add it to the team.
    private func chooseCharacter() {
        // announce
        let characterIndex = Player.characters.count - 3 * self.index + 1
        switch characterIndex {
        case 1:
            StyleSheet.displayMiniTitle("Choose your 1st character")
        case 2:
            StyleSheet.displayMiniTitle("Choose your 2nd character")
        case 3:
            StyleSheet.displayMiniTitle("Choose your 3rd character")
        default:
            print("Fatal Error in characters type asking.")
            exit(0)
        }
        // choose type
        let type = chooseCharacterType()
        print("Your choice : \(type.emoticon()) \(type.name())")
        // choose name
        let name = chooseCharacterName()
        StyleSheet.displayDashLine()
        // character's creation
        let character = Character(name: name, type: type)
        StyleSheet.displayMiniTitle("Character created")
        // ask confirmation
        if isCharacterConfirmed(character) {
            Player.characters.append(character)
            print("\(character.name) has been added to your team !")
            StyleSheet.displayDashLine()
        } else {
            print("\(character.name) has been deleted.")
            StyleSheet.displayDashLine()
        }
    }
    
    /// Ask confirmation for adding character in the player's team.
    /// - parameter character: Character to be confirmed.
    /// - returns: *true* if the character has been confirmed in the team, *false* otherwise.
    private func isCharacterConfirmed(_ character: Character) -> Bool {
        let info = character.displayInformations(full: false, evenDead: false)
        guard let verifiedInfo = info else {
            print("Fatal Erro : character's informations return nil.")
            exit(0)
        }
        print(verifiedInfo)
        return Ask.confirmation("Do you confirm ?")
    }
    
    /// Let user choose the character's type.
    /// - returns: The character's type.
    private func chooseCharacterType() -> CharacterType {
        displayCharactersTypes()
        let types: [CharacterType] = [.warrior, .wizard, .druid, .joker]
        var numberToReturn: Int? = nil
        var explanationAbout = "strength and healthcare"
        if BACProperties.isSpecialSkillEnabled {
            explanationAbout = "special skill, \(explanationAbout)"
        }
        while numberToReturn == nil {
            let number = Ask.number(
            range: 1...4,
            message: "\nChoose a character type by enter a number between 1 and 4.",
            cancelProposition: "✧ Choose 0 to have some explanations about \(explanationAbout).")
            if number == 0 {
                Game.displayStrengthAndHealthcareInformations()
            } else {
                numberToReturn = number
            }
        }
        guard let number = numberToReturn else {
            print("Fatal Error : choosen number returns nil.")
            exit(0)
        }
        return types[number - 1]
    }
    
    /// Display all character's type possibilities.
    func displayCharactersTypes() {
        let types: [CharacterType] = [.warrior, .wizard, .druid, .joker]
        for index in 0...3 {
            types[index].displayInformations()
        }
    }
    
    /// Let user choose a name for the character.
    /// - returns: The choosen name.
    private func chooseCharacterName() -> String {
        // ask name
        var choosenName: String? = nil
        while choosenName == nil {
            choosenName = askName()
        }
        guard let verifiedChoosenName = choosenName else {
            print("Fatal Error : ChoosenName returns nil.")
            exit(0)
        }
        // returns it
        return verifiedChoosenName
    }
    
    /// Ask  a name for the character and returns it.
    private func askName() -> String? {
        // ask name
        let name = Ask.freeAnswer("\nEnter its name :")
        if isTakenName(name) {
            print("This name is already used by another character. Choose another.")
            return nil
        }
        if name.count > 30 {
            print("Please enter a shorter name.")
            return nil
        }
        return name
    }
    
    /// Remove all characters of the player's team.
    func removeCharacters() {
        for _ in 0...2 {
            Player.characters.remove(at: index * 3)
        }
    }
    
    
    
        // MARK: Situation
    
    
    
    /// Display team's situation.
    /// - parameter playerIndex : Index of the needed player in Game.players.
    func displayTeamSituation(_ playerIndex: Int) {
        if playerIndex == index {
            print("\n\(name)'s team [HP : \(HPSituation) %]")
        }
    }
}
