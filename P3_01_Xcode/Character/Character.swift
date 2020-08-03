//
//  Character.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

class Character {

    // MARK: - Properties

    /// Character's name.
    let name: String

    /// Character's type.
    let type: CharacterType

    /// Character's weapon.
    var weapon: Weapon

    /// Character's skills.
    let skills: [Skill]

    /// Character's health points.
    var healthPoints: Int {
        return type.maxHealthPoints() - injuriesPoints + healPoints
    }

    /// Sustained injuries points by the character.
    var injuriesPoints: Int = 0

    /// Received heal points by the character.
    var healPoints: Int = 0

    /// Life step of the character. Allows to know if the character is dying.
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

    /// Is the character dead ? *true* if the answer is yes, *false* otherwise.
    var isDead: Bool { // based on its healthpoints, is the character dead ?
        return healthPoints == 0 ? true : false
    }

    /// Character's strength, based on its weapon's strength and its capability to be concentrated.
    var strength: Int{
        return isDiverted ? weapon.strength - Int.random(in: 0...weapon.strength) / 2 : weapon.strength
    }

    /// Character's healthcare's capability based on its strength and healthcare's coefficient.
    var healthCare: Int {
        return Int(Double(strength) * type.healthCareCoefficient())
    }

    /// Is the character diverted by a Joker ? *true* if the answer is yes, *false* otherwise.
    var isDiverted: Bool{
        return diversionRounds != nil
    }

    /// If the character is diverted, for how many rounds ? Returns *nil* if the character is not diverted.
    var diversionRounds: Int? = nil

    /// Availability of the character's special skill. When a character use its special skill, its availability change into *.used*. At the round's end, it will change into *.unavailable* to impeach user to use it next round. And, at the next round's end, it will change to *.available* again.
    var specialSkillIsAvailable: SpecialSkillAvailability = .available

    // MARK: - Init

    init(name: String, type: CharacterType) {
        self.name = name
        self.type = type
        self.weapon = type.createWeapon(for: nil)
        if BACProperties.specialSkillIsEnabled {
            self.skills = [.attack, .heal, type.specialSkill()] // all characters can use attack and heal, specialskill depends on its type
        } else {
            self.skills = [.attack, .heal]
        }
    }

    // MARK: - Using skills

    /// Ask character to use its skill.
    func executeOrder() {
        let round = Game.returnActiveRound()
        let skill = round.existingChoosenSkill()
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

    // MARK: - Character's informations

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
        for index in 0...skills.count - 1 {
            if index < 2 {
                print("\(index + 1). \(skills[index].name())")
            } else {
                print("\(index + 1). \(skills[index].name()) \(specialSkillIsAvailable.rawValue)")
            }
        }
    }
}



