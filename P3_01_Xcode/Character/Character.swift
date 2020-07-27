//
//  Character.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

class Character {
    
    
    
        // MARK: Properties
    
    
    
    let name: String // name of the character
    let type: CharacterType // type of the character
    var weapon: Weapon // weapon of the character
    var healthPoints: Int { // computes the healthpoints the character actually have
        return type.maxHealthPoints() - injuriesPoints + healPoints
    }
    var injuriesPoints: Int = 0 // injuries points suffered by the character
    var healPoints: Int = 0 // heal points getted by the character
    var activeStep: LifeStep { // based on its healthpoints, is the character dying ?
        switch healthPoints {
        case type.maxHealthPoints():
            return .fulLife
        case let x where x < 60:
            return .endLife
        default:
            return .midLife
        }
    }
    var isDead: Bool { // based on its healthpoints, is the character dead ?
        return healthPoints == 0 ? true : false
    }
    var strength: Int{
        // strength of a character depends on the strength of its weapon. If diverted, it loses parts of its value
        return isDiverted ? weapon.strength - Int.random(in: 0...weapon.strength) / 2 : weapon.strength
    }
    var healthCare: Int {
        //healthCare of the character depends on his strength and his healthcare coefficient.
        return Int(Double(strength) * type.healthCareCoefficient())
    }
    let skills: [Skill] // skills of the character
    var diversionRounds: Int? // if the character suffers of diversion, for how many rounds ?
    var isDiverted: Bool{
        //Characters could be diverted by a joker. The diversion can last up to 4 rounds. This computed variable check if the character is still diverted.
        return diversionRounds != nil
    }
    var specialSkillIsAvailable: SpecialSkillAvailability = .available
    
    
    
        // MARK: Init
    
    
    
    init(name: String, type: CharacterType) {
        self.name = name
        self.type = type
        self.weapon = type.createWeapon(firstWeapon: true, lifeStep: .fulLife)
        self.skills = [.attack, .heal, type.specialSkill()] // all characters can use attack and heal, specialskill depends on its type
    }
    
    
    
        // MARK: Using skills
    
    
    
    /// Ask character to use its skill.
    func executeOrder66() {
        let round = Game.returnActiveRound()
        let skill = round.isChooseSkillExisting()
        var target: [Character]
        if let aloneTarget = round.choosenTargetCharacter {
            target = [aloneTarget]
        } else {
            switch skill {
            case .multiAttack:
                target = round.watchingPlayer.characters
            case .multiHeal:
                target = round.playingPlayer.characters
            default:
                print("Fatal Error : target is not selected.")
                exit(0)
            }
        }
        skill.use(user: self, target: target)
    }
    
    /// Switch special skill availability to used. Next round, the special skill will be unavailable
    func specialSkillIsUsed() {
        specialSkillIsAvailable = .used
    }
    
    
    
        // MARK: Character's informations
    
    
    
    /// Display informations about the character.
    /// - parameter full : Return full informations of the character.
    /// - parameter evenDead : Return character's informations, even if the character is dead.
    /// - returns: Character's informations or nil if the character is dead.
    func displayInformations(full: Bool, evenDead: Bool) -> String? {
        var preIndex: Int? = nil
        if Player.characters.count > 0 {
            for searchIndex in 0...Player.characters.count - 1 {
                if Player.characters[searchIndex].name == name {
                    preIndex = searchIndex
                    break
                }
            }
        }
        let emoticon: String
        if isDiverted {
            emoticon = "🤪"
        } else if isDead {
            emoticon = "💀"
        } else {
            emoticon = self.type.emoticon()
        }
        if full {
            if evenDead || !isDead {
                guard let index = preIndex else {
                    print("Fatal Error : character not found in Player.characters.")
                    exit(0)
                }
                return "\(index + 1). \(self.type.initials()) \(emoticon) \(name) : [Str. \(strength)] [HP \(healthPoints)/\(self.type.maxHealthPoints())]"
            }
        } else {
            if evenDead || !isDead {
                return "\(self.type.initials()) \(self.type.emoticon()) \(name)"
            }
        }
        return nil
    }
    
    /// Display skills of the character.
    func displaySkills() {
        for index in 0...2 {
            print("\(index + 1). \(skills[index].name()) \(specialSkillIsAvailable.rawValue)")
        }
    }
}



