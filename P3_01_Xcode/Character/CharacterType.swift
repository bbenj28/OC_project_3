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
        switch self {
        case .warrior:
            return BACProperties.warriorName
        case .wizard:
            return BACProperties.wizardName
        case .druid:
            return BACProperties.druidName
        case .joker:
            return BACProperties.jokerName
        }
    }

    /// Ask for charactertype's initials.
    /// - returns: Charactertype's initials.
    func initials() -> String {
        switch self {
        case .warrior:
            return BACProperties.warriorInitials
        case .wizard:
            return BACProperties.wizardInitials
        case .druid:
            return BACProperties.druidInitials
        case .joker:
            return BACProperties.jokerInitials
        }
    }

    /// Ask for charactertype's emoticon.
    /// - returns: Charactertype's emoticon.
    func emoticon() -> String {
        switch self {
        case .warrior:
            return BACProperties.warriorEmoticon
        case .wizard:
            return BACProperties.wizardEmoticon
        case .druid:
            return BACProperties.druidEmoticon
        case .joker:
            return BACProperties.jokerEmoticon
        }
    }

    /// Ask for charactertype's description.
    /// - returns: Charactertype's description.
    private func description() -> String {
        switch self {
        case .warrior:
            return BACProperties.warriorDescription
        case .wizard:
            return BACProperties.wizardDescription
        case .druid:
            return BACProperties.druidDescription
        case .joker:
            return BACProperties.jokerDescription
        }
    }

    /// Ask for charactertype's maximum health points.
    /// - returns: Charactertype's maximum health points.
    func maxHealthPoints() -> Int {
        switch self {
        case .warrior:
            return BACProperties.warriorMaxHealthPoints
        case .wizard:
            return BACProperties.wizardMaxHealthPoints
        case .druid:
            return BACProperties.druidMaxHealthPoints
        case .joker:
            return BACProperties.jokerMaxHealthPoints
        }
    }

    /// Ask for charactertype's healthcare coefficient.
    /// - returns: Charactertype's healthcare coefficient.
    func healthCareCoefficient() -> Double {
        switch self {
        case .warrior:
            return BACProperties.warriorHealthCareCoefficient
        case .wizard:
            return BACProperties.wizardHealthCareCoefficient
        case .druid:
            return BACProperties.druidHealthCareCoefficient
        case .joker:
            return BACProperties.jokerHealthCareCoefficient
        }
    }

    /// Ask for charactertype's special skill.
    /// - returns: Charactertype's special skill.
    func specialSkill() -> Skill {
        switch self {
        case .warrior:
            return BACProperties.warriorSpecialSkill
        case .wizard:
            return BACProperties.wizardSpecialSkill
        case .druid:
            return BACProperties.druidSpecialSkill
        case .joker:
            return BACProperties.jokerSpecialSkill
        }
    }

    /// Ask for charactertype's weapon's type.
    /// - returns: Charactertype's weapon's type.
    private func weaponType() -> WeaponType {
        switch self {
        case .warrior:
            return BACProperties.warriorWeaponType
        case .wizard:
            return BACProperties.wizardWeaponType
        case .druid:
            return BACProperties.druidWeaponType
        case .joker:
            return BACProperties.jokerWeaponType
        }
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
        if BACProperties.isSpecialSkillEnabled {
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
