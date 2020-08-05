//
//  Balance&CustomizableProperties.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 06/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

// MARK: BACProperties

struct BACProperties {
    // for Balance And Customizable Properties

    //MARK: - Game

    /// Random players and characters creations. *true* for creating random players and characters.
    static let randomCreation: Bool = false

    // MARK: - Chest

    /// Chances to get a chest at the round's end.
    /// ```
    /// usage :
    /// chestChances = 4
    /// > means user has 1 chance out of 4 to find a chest.
    /// ``
    static let chestChances = 4

    // MARK: - Specialskills

    /// Enable special skill use by user if its value is *true*.
    static let specialSkillIsEnabled = true

    /// Description of the special skill.
    static let multiAttackDescription = "Their specialskill allows them to attack several enemies with one action."

    /// Description of the special skill.
    static let multiHealDescription = "Their specialskill allows them to heal several allies with one action."

    /// Description of the special skill.
    static let diversionDescription = "Their specialskill allows them to distract an enemy during several rounds."

    /// Maximum number of rounds during which a character can be diverted.
    /// ```
    /// usage :
    /// diversionMaxRound = 4
    /// > means target can be diverted during 1 to 4 rounds.
    /// ```
    static let diversionMaxRound = 4

    // MARK: - Characters Types

    /// Name of character's type.
    static let charactersTypeName: [CharacterType: String] = [
        .warrior: "Warrior",
        .wizard: "Wizard",
        .druid: "Druid",
        .joker: "Joker"]

    /// Initials of character's type.
    /// ```
    /// example : [Jo] for Jokers.
    /// ```
    static let charactersTypeInitials: [CharacterType: String] = [
        .warrior: "[Wa]",
        .wizard: "[Wi]",
        .druid: "[Dr]",
        .joker: "[Jo]"]

    /// Emoticon of character's type.
    /// ```
    /// example : 🃏 for Jokers.
    /// ```
    static let charactersTypeEmoticon: [CharacterType: String] = [
        .warrior: "💂",
        .wizard: "🧙",
        .druid: "🧑‍⚕️",
        .joker: "🃏"]
    
    /// Description of character's type.
    static let charactersTypeDescription: [CharacterType: String] = [
        .warrior: "The strongest recruit you will see. Warriors are naturally born to kill. They are the most resistants soldiers and their strength will cause many damages.",
        .wizard: "Beware! Behind their frail appearance, the witchers are no less formidable. They aren't very resistants, but their PowerStick gives them great strength.",
        .druid: "In communion with nature and their environment, druids are pleased to take care of others. Their ability to heal is second to none.",
        .joker: "Not really resistant, not strong either and without healing power, jokers can nevertheless, through their humor, distract enemies and give you an advantage."]

    /// Maximum health points of character's type.
    static let charactersTypeMaxHealthPoints: [CharacterType: Int] = [
        .warrior: 100,
        .wizard: 50,
        .druid: 50,
        .joker: 50]

    /// Healthcare coefficient of character's type.
    static let charactersTypeHealthCareCoefficient: [CharacterType: Double] = [
        .warrior: 0.2,
        .wizard: 0.2,
        .druid: 2,
        .joker: 0.5]

    /// Special skill of character's type.
    static let charactersTypeSpecialSkill: [CharacterType: Skill] = [
        .warrior: .multiAttack,
        .wizard: .multiAttack,
        .druid: .multiHeal,
        .joker: .diversion]

    /// Weapon's type of character's type.
    static let charactersTypeWeaponType: [CharacterType: WeaponType] = [
        .warrior: .sword,
        .wizard: .powerStick,
        .druid: .healthStick,
        .joker: .knife]

    // MARK: - Weapons

    /// Can life step of a character be used to determine the strength of its weapon to be created ? *true* if life step can be used, *false* otherwise.
    static let areLifeStepsUseFull: Bool = true

    /// Name of weapon's type.
    static let weaponsTypeName: [WeaponType: String] = [
        .sword: "Sword",
        .powerStick: "PowerStick",
        .healthStick: "HealthStick",
        .knife: "Knife"]

    /// Minimum strength of a weapon's type regarding the life step of the future owner.
    static let weaponsTypeMinStrength: [WeaponType: [LifeStep: Int]] = [
        .sword: [.fulLife: 50, .midLife: 65, .endLife: 85],
        .powerStick: [.fulLife: 70, .midLife: 85, .endLife: 105],
        .healthStick: [.fulLife: 20, .midLife: 35, .endLife: 55],
        .knife: [.fulLife: 30, .midLife: 45, .endLife: 65]]
    
    /// Maximum strength of a weapon's type.
    static let weaponsTypeMaxStrength: [WeaponType: Int] = [
        .sword: 100,
        .powerStick: 120,
        .healthStick: 70,
        .knife: 80]
}
