//
//  CharacterType.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 27/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation

enum CharacterType {

    // the differents types of a character
    case warrior
    case wizard
    case druid
    case joker

    // MARK: - Informations

    /// Ask for charactertype's name.
    /// - returns: Charactertype's name.
    func name() -> String {
        guard let name = BACProperties.charactersTypeName[self] else {
            print("Fatal Error : Character's type's name returns nil.")
            exit(0)
        }
        return name
    }

    /// Ask for charactertype's initials.
    /// - returns: Charactertype's initials.
    func initials() -> String {
        guard let initials = BACProperties.charactersTypeInitials[self] else {
            print("Fatal Error : Character's type's initials returns nil.")
            exit(0)
        }
        return initials
    }

    /// Ask for charactertype's emoticon.
    /// - returns: Charactertype's emoticon.
    func emoticon() -> String {
        guard let emoticon = BACProperties.charactersTypeEmoticon[self] else {
            print("Fatal Error : Character's type's emoticon returns nil.")
            exit(0)
        }
        return emoticon
    }

    /// Ask for charactertype's description.
    /// - returns: Charactertype's description.
    private func description() -> String {
        guard let description = BACProperties.charactersTypeDescription[self] else {
            print("Fatal Error : Character's type's description returns nil.")
            exit(0)
        }
        return description
    }

    /// Ask for charactertype's maximum health points.
    /// - returns: Charactertype's maximum health points.
    func maxHealthPoints() -> Int {
        guard let maxHP = BACProperties.charactersTypeMaxHealthPoints[self] else {
            print("Fatal Error : Character's type's maximum HP returns nil.")
            exit(0)
        }
        return maxHP
    }

    /// Ask for charactertype's healthcare coefficient.
    /// - returns: Charactertype's healthcare coefficient.
    func healthCareCoefficient() -> Double {
        guard let HCCoefficient = BACProperties.charactersTypeHealthCareCoefficient[self] else {
            print("Fatal Error : Character's type's Healthcare coefficient returns nil.")
            exit(0)
        }
        return HCCoefficient
    }

    /// Ask for charactertype's special skill.
    /// - returns: Charactertype's special skill.
    func specialSkill() -> Skill {
        guard let skill = BACProperties.charactersTypeSpecialSkill[self] else {
            print("Fatal Error : Character's type's special skill returns nil.")
            exit(0)
        }
        return skill
    }

    /// Ask for charactertype's weapon's type.
    /// - returns: Charactertype's weapon's type.
    private func weaponType() -> WeaponType {
        guard let weapon = BACProperties.charactersTypeWeaponType[self] else {
            print("Fatal Error : Character's type's weapon's type returns nil.")
            exit(0)
        }
        return weapon
    }

    /// Ask for charactertype's index (number to enter to choose its type).
    /// - returns: Charactertype's index.
    private func index() -> Int {
        switch self {
        case .warrior:
            return 1
        case .wizard:
            return 2
        case .druid:
            return 3
        case .joker:
            return 4
        }
    }

    /// Display informations about strength, healthcare, and eventually special skill.
    func displayInformations() {
        print("\n\(index()). \(emoticon()) \(name())")
        if BACProperties.specialSkillIsEnabled {
            print("\(description()) \(specialSkill().description())")
            print("[maximum HP: \(maxHealthPoints())] [min. strength✧ : \(weaponType().minStrength(.fulLife))] [min. healthcare✧ : \(Int(healthCareCoefficient() * Double(weaponType().minStrength(.fulLife))))] [special skill✧ : \(specialSkill().name())]")
        } else {
            print("\(description())")
            print("[maximum HP: \(maxHealthPoints())] [min. strength✧ : \(weaponType().minStrength(.fulLife))] [min. healthcare✧ : \(Int(healthCareCoefficient() * Double(weaponType().minStrength(.fulLife))))]")
            
        }
    }

    // MARK: - Weapon creation

    /// Create a weapon regading type.
    /// - parameter firstWeapon: Will this weapon be the character's first ?
    /// - parameter lifeStep: Active life step of the character.
    /// - returns: The generated weapon.
    func createWeapon(for character: Character?) -> Weapon {
        if let receiver = character {
            return Weapon(type: weaponType(), firstWeapon: false, lifeStep: receiver.activeStep)
        } else {
            return Weapon(type: weaponType(), firstWeapon: true, lifeStep: .fulLife)
        }
    }
}
