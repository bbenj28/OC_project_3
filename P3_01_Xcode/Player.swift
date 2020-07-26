//
//  Player.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

// MARK: Player

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
            maxHP += Double(Player.characters[index].maxHealthPoints)
            HP += Double(Player.characters[index].healthPoints)
        }
        return Int(HP / maxHP * 100)
    }
    
        // MARK: Init
    init(name: String, index: Int) {
        self.name = name
        self.index = index
    }
    
        // MARK: Random characters
    /// Manage random characters creation.
    static func randomCharactersCreation() {
        // characters creation [random]
        while Player.characters.count < 6 {
            Player.characters.append(randomSingleCharacter())
        }
    }
    /// Choose name and type of a character and returns it.
    static private func randomSingleCharacter() -> Character {
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
        let type = Int.random(in: 1...4)
        switch type {
        case 1:
            return Warrior(name: verifiedName, weapon: Sword(firstWeapon: true, lifeStep: .fulLife))
        case 2:
            return Wizard(name: verifiedName, weapon: PowerStick(firstWeapon: true, lifeStep: .fulLife))
        case 3:
            return Druid(name: verifiedName, weapon: HealthStick(firstWeapon: true, lifeStep: .fulLife))
        case 4:
            return Joker(name: verifiedName, weapon: Knife(firstWeapon: true, lifeStep: .fulLife))
        default:
            print("Fatal Error : randomCharacterType have to be a number between 1 and 4.")
            exit(0)
        }
    }
    /// Choose the character's name in a list by drawing a random number.
    /// - returns: If the name is already used by another character, returns nil; otherwise returns the name.
    static private func randomName() -> String? {
        // names list
        let names = ["Arthur", "Guenièvre", "Merlin", "Léodagan", "Séli", "Bohort", "Perceval", "Caradoc", "Mevanwi", "Calogrenan", "Lancelot", "Lot", "Dagonnet", "Yvain", "Gauvain", "Galcin", "Angarade", "La Dame du Lac"]
        // random number
        let index = Int.random(in: 0...names.count - 1)
        // check if the name is already used by another character
        if Player.characters.count > 0 {
            for character in Player.characters {
                if character.name == names[index] {
                    return nil
                }
            }
        }
        // returns it
        return names[index]
    }
    
    
        // MARK: Characters creation by user
    func userCharactersCreation() {
        // characters creation [by user]
        // iterate characters creation until all characters have been created
        StyleSheet.displaySubTitle("\(name)")
        var confirmation: Bool = false
        while confirmation == false {
            while Player.characters.count < 3 * index + 3 {
                chooseCharacter()
            }
            if teamConfirmation() {
                print("Your team has been created.")
                StyleSheet.displayStarLine()
                confirmation = true
            } else {
                print("Your choices have been canceled. Please, choose others characters.")
                StyleSheet.displayStarLine()
                removeCharacters()
            }
        }
    }
    private func teamConfirmation() -> Bool {
        StyleSheet.displayMiniTitle("Here's your team")
        for index in 0...2 {
            let info = characters[index].informations(full: false, evenDead: false)
            guard let verifiedInfo = info else {
                print("Fatal Error : character's informations returns nil.")
                exit(0)
            }
            print(verifiedInfo)
        }
        return Ask.confirmation("Do you confirm ?")
    }
    private func chooseCharacter() {
        let characterIndex = Player.characters.count - 3 * self.index + 1
        switch characterIndex {
        case 1:
            print("\n*******\nChoose your first character : ")
        case 2:
            print("\n*******\nFine, now choose your second character : ")
        case 3:
            print("\n*******\nOk! Finally, choose your last character : ")
        default:
            print("Fatal Error in characters type asking.")
            exit(0)
        }
        let type = chooseCharacterType(characterIndex)
        let name = chooseCharacterName()
        let character = characterCreation(name: name, type: type)
        StyleSheet.displayMiniTitle("Character created")
        let info = character.informations(full: false, evenDead: false)
        guard let verifiedInfo = info else {
            print("Fatal Erro : character's informations return nil.")
            exit(0)
        }
        print(verifiedInfo)
        if Ask.confirmation("Do you confirm ?") {
            Player.characters.append(character)
            print("\(character.name) has been added to your team !")
            StyleSheet.displayStarLine()
        } else {
            print("\(character.name) has been deleted.")
            StyleSheet.displayStarLine()
        }
    }
    func chooseCharacterType(_ characterIndex: Int) -> CharacterType {
        displayCharactersTypes()
        let types: [CharacterType] = [.warrior, .wizard, .druid, .joker]
        let number = Ask.number(
            range: 1...4,
            message: "Choose a character type by enter a number between 1 and 4.",
            cancelProposition: nil)
        return types[number - 1]
    }
    func displayCharactersTypes() {
        guard let specialSkillDescriptionWa = specialSkillDescription(bacproperties.warriorSpecialSkill) else {
            print("Fatal Error : Unknown special skill description (1).")
            exit(0)
        }
        print("1. \(bacproperties.warriorEmoticon) \(bacproperties.warriorName) : \(bacproperties.warriorDescription) \(specialSkillDescriptionWa)")
        guard let specialSkillDescriptionWi = specialSkillDescription(bacproperties.wizardSpecialSkill) else {
            print("Fatal Error : Unknown special skill description (2).")
            exit(0)
        }
        print("2. \(bacproperties.wizardEmoticon) \(bacproperties.wizardName) : \(bacproperties.wizardDescription) \(specialSkillDescriptionWi)")
        guard let specialSkillDescriptionDr = specialSkillDescription(bacproperties.druidSpecialSkill) else {
            print("Fatal Error : Unknown special skill description (3).")
            exit(0)
        }
        print("3. \(bacproperties.druidEmoticon) \(bacproperties.druidName) : \(bacproperties.druidDescription) \(specialSkillDescriptionDr)")
        guard let specialSkillDescriptionJo = specialSkillDescription(bacproperties.jokerSpecialSkill) else {
            print("Fatal Error : Unknown special skill description (4).")
            exit(0)
        }
        print("4. \(bacproperties.jokerEmoticon) \(bacproperties.jokerName) : \(bacproperties.jokerDescription) \(specialSkillDescriptionJo)")
    }
    func specialSkillDescription(_ specialSkill: SkillsType) -> String? {
        switch specialSkill {
        case .multiAttack:
            return bacproperties.multiAttackDescription
        case .multiHeal:
            return bacproperties.multiHealDescription
        case .diversion:
            return bacproperties.diversionDescription
        default:
            return nil
        }
    }
    func chooseCharacterName() -> String {
        var choosenName: String? = nil
        while choosenName == nil {
            choosenName = askName()
        }
        guard let verifiedChoosenName = choosenName else {
            print("Fatal Error : ChoosenName returns nil.")
            exit(0)
        }
        return verifiedChoosenName
    }
    func askName() -> String? {
        let name = Ask.freeAnswer("Enter its name :")
        if Player.characters.count > 0 {
            for character in Player.characters {
                if character.name.lowercased() == name.lowercased() {
                    print("This name is already used by another character. Choose another.")
                    return nil
                }
            }
        }
        if name.count > 30 {
            print("Please enter a shorter name.")
            return nil
        }
        return name
    }
    func characterCreation(name: String, type: CharacterType) -> Character {
        switch type {
        case .warrior:
            let weapon = Sword(firstWeapon: true, lifeStep: .fulLife)
            return Warrior(name: name, weapon: weapon)
        case .wizard:
            let weapon = PowerStick(firstWeapon: true, lifeStep: .fulLife)
            return Wizard(name: name, weapon: weapon)
        case .druid:
            let weapon = HealthStick(firstWeapon: true, lifeStep: .fulLife)
            return Druid(name: name, weapon: weapon)
        case .joker:
            let weapon = Knife(firstWeapon: true, lifeStep: .fulLife)
            return Joker(name: name, weapon: weapon)
        }
    }
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
