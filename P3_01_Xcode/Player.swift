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
    let name: String // player's name choosen in the home view
    static var characters: [Character] = [] // list of players characters
    let index: Int
    var isDefeated: Bool {
        return Player.characters[2 * index + 1].isDead && Player.characters[2 * index + 2].isDead && Player.characters[2 * index + 3].isDead
    }
    var HPSituation: Int {
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
    
    func chooseCharacter() {
        let characterIndex = Player.characters.count - 3 * self.index + 1
        switch characterIndex {
        case 1:
            print("\n*******\n\(name), choose your first character : ")
        case 2:
            print("\n*******\nFine, now choose your second character : ")
        case 3:
            print("\n*******\nOk! Finally, choose your last character : ")
        default:
            print("Fatal Error in characters type asking.")
            exit(0)
        }
        let type = chooseCharacterType(characterIndex)
        print(type)
        let name = chooseCharacterName()
        let character = characterCreation(name: name, type: type)
        Player.characters.append(character)
    }
    func chooseCharacterType(_ characterIndex: Int) -> CharacterType {
        displayCharactersTypes()
        var choosenType: CharacterType?
        while choosenType == nil {
            choosenType = askType()
        }
        guard let verifiedChoosenType = choosenType else {
            print("Fatal Error : ChoosenType returns nil.")
            exit(0)
        }
        return verifiedChoosenType
    }
    func displayCharactersTypes() {
        guard let specialSkillDescriptionWa = specialSkillDescription(bacproperties.warriorSpecialSkill) else {
            print("Fatal Error : Unknown special skill description (1).")
            exit(0)
        }
        print("1. \(bacproperties.warriorName) : \(bacproperties.warriorDescription) \(specialSkillDescriptionWa)")
        guard let specialSkillDescriptionWi = specialSkillDescription(bacproperties.wizardSpecialSkill) else {
            print("Fatal Error : Unknown special skill description (2).")
            exit(0)
        }
        print("2. \(bacproperties.wizardName) : \(bacproperties.wizardDescription) \(specialSkillDescriptionWi)")
        guard let specialSkillDescriptionDr = specialSkillDescription(bacproperties.druidSpecialSkill) else {
            print("Fatal Error : Unknown special skill description (3).")
            exit(0)
        }
        print("3. \(bacproperties.druidName) : \(bacproperties.druidDescription) \(specialSkillDescriptionDr)")
        guard let specialSkillDescriptionJo = specialSkillDescription(bacproperties.jokerSpecialSkill) else {
            print("Fatal Error : Unknown special skill description (4).")
            exit(0)
        }
        print("4. \(bacproperties.jokerName) : \(bacproperties.jokerDescription) \(specialSkillDescriptionJo)")
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
    func askType() -> CharacterType? {
        let types: [CharacterType] = [.warrior, .wizard, .druid, .joker]
        print ("Choose a number between 1 and 4 :")
        let choice = readLine()
        guard let existingChoice = choice else {
            return nil
        }
        if let numberChoice = Int(existingChoice) {
            if numberChoice > 0 && numberChoice < 5 {
                return types[numberChoice - 1]
            }
        }
        return nil
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
        print("What's its name ?")
        let name = readLine()
        guard let verifiedName = name else {
            return nil
        }
        if verifiedName == "" {
            return nil
        }
        if Player.characters.count > 0 {
            for character in Player.characters {
                if character.name.lowercased() == verifiedName.lowercased() {
                    print("This name is already used by another character. Choose another.")
                    return nil
                }
            }
        }
        return verifiedName
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
}
