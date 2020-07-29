//
//  Balance&CustomizableProperties.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 06/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

// MARK: BACProperties

class BACProperties {
    // for Balance And Customizable Properties
    
    //MARK: - Game
    
    /// Random players and characters creations. *true* for creating random players and characters.
    static var randomCreation: Bool = false
    
    /// Strength explanation.
    static let strengthExplanations = "\n✧ Strength : when a character attacks another, this target receive injuries points. Injuries points are at least a half of the offenser's strength. The character's strength depends on its weapon's. The PowerSticks of the wizards have the highest strength potential. However, if the character is diverted by a joker, its strength is multiplied by a coefficient between 0 and 0.5, which change all the time. \n value = weapon's strength × diversion's coefficient."
    
    /// Healthcare explanation.
    static let healthcareExplanations = "\n✧ Healthcare's capability : when a character heals another, this target receives heal points. Heal points are at least a half of the healer's healthcare's capability. The character's healthcare's capability depends on its strength and its healthcare coefficient. This coefficient depends on the character's type. Druids have the highest healthcare coefficient. \n value = character's strength × healthcare coefficient\n"
    
    
    
    // MARK: Chest
    
    
    
    /// Chances to get a chest at the round's end.
    /// ```
    /// usage :
    /// chestChances = 4
    /// > means user has 1 chance out of 4 to find a chest.
    /// ``
    static let chestChances = 4
    
    
    
    // MARK: Specialskills
    
    
    /// Enable special skill use by user if its value is *true*.
    static let isSpecialSkillEnabled = true
    
    /// Explanations to display about special skills.
    static let specialSkillExplanations = "\n✧ Special skill : each character has a special skill. This skill depends on the character's type. If a character use its special skill, it can not use it the next round."
    
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
    
    
    
    // MARK: Characters Types
    
    
    
    // MARK: Warrior
    
    
    
    /// Name of character's type.
    static let warriorName = "Warrior"
    
    /// Initials of character's type.
    /// ```
    /// example : [Jo] for Jokers.
    /// ```
    static let warriorInitials = "[Wa]"
    
    /// Emoticon of character's type.
    /// ```
    /// example : 🃏 for Jokers.
    /// ```
    static let warriorEmoticon = "💂"
    
    /// Description of character's type.
    static let warriorDescription = "The strongest recruit you will see. Warriors are naturally born to kill. They are the most resistants soldiers and their strength will cause many damages."
    
    /// Maximum health points of character's type.
    static let warriorMaxHealthPoints: Int = 300
    
    /// Healthcare coefficient of character's type.
    static let warriorHealthCareCoefficient: Double = 0.2
    
    /// Special skill of character's type.
    static let warriorSpecialSkill: Skill = .multiAttack
    
    /// Weapon's type of character's type.
    static let warriorWeaponType: WeaponType = .sword
    
    
    
    // MARK: Wizard
    
    
    
    /// Name of character's type.
    static let wizardName = "Wizard"
    
    /// Initials of character's type.
    /// ```
    /// example : [Jo] for Jokers.
    /// ```
    static let wizardInitials = "[Wi]"
    
    /// Emoticon of character's type.
    /// ```
    /// example : 🃏 for Jokers.
    /// ```
    static let wizardEmoticon = "🧙"
    
    /// Description of character's type.
    static let wizardDescription = "Beware! Behind their frail appearance, the witchers are no less formidable. They aren't very resistants, but their PowerStick gives them great strength."
    
    /// Maximum health points of character's type.
    static let wizardMaxHealthPoints: Int = 150
    
    /// Healthcare coefficient of character's type.
    static let wizardHealthCareCoefficient: Double = 0.3
    
    /// Special skill of character's type.
    static let wizardSpecialSkill: Skill = .multiAttack
    
    /// Weapon's type of character's type.
    static let wizardWeaponType: WeaponType = .powerStick
    
    
    
    // MARK: Druid
    
    
    
    /// Name of character's type.
    static let druidName = "Druid"
    
    /// Initials of character's type.
    /// ```
    /// example : [Jo] for Jokers.
    /// ```
    static let druidInitials = "[Dr]"
    
    /// Emoticon of character's type.
    /// ```
    /// example : 🃏 for Jokers.
    /// ```
    static let druidEmoticon = "🧑‍⚕️"
    
    /// Description of character's type.
    static let druidDescription = "In communion with nature and their environment, druids are pleased to take care of others. Their ability to heal is second to none."
    
    /// Maximum health points of character's type.
    static let druidMaxHealthPoints: Int = 150
    
    /// Healthcare coefficient of character's type.
    static let druidHealthCareCoefficient: Double = 2
    
    /// Special skill of character's type.
    static let druidSpecialSkill: Skill = .multiHeal
    
    /// Weapon's type of character's type.
    static let druidWeaponType: WeaponType = .healthStick
    
    
    
    // MARK: Joker
    
    
    
    /// Name of character's type.
    static let jokerName = "Joker"
    
    /// Initials of character's type.
    /// ```
    /// example : [Jo] for Jokers.
    /// ```
    static let jokerInitials = "[Jo]"
    
    /// Emoticon of character's type.
    /// ```
    /// example : 🃏 for Jokers.
    /// ```
    static let jokerEmoticon = "🃏"
    
    /// Description of character's type.
    static let jokerDescription = "Not really resistant, not strong either and without healing power, jokers can nevertheless, through their humor, distract enemies and give you an advantage."
    
    /// Maximum health points of character's type.
    static let jokerMaxHealthPoints: Int = 200
    
    /// Healthcare coefficient of character's type.
    static let jokerHealthCareCoefficient: Double = 0.5
    
    /// Special skill of character's type.
    static let jokerSpecialSkill: Skill = .diversion
    
    /// Weapon's type of character's type.
    static let jokerWeaponType: WeaponType = .knife
    
    
    
    // MARK: Weapons
    
    
    
    /// Can life step of a character be used to determine the strength of its weapon to be created ? *true* if life step can be used, *false* otherwise.
    static let areLifeStepsUseFull: Bool = true
    
    
    
    // MARK: Sword (warrior's weapon)
    
    
    
    /// Name of weapon's type.
    static let swordName = "Sword"
    
    /// Minimum strength of a weapon's type regarding the life step of the future owner.
    static let swordMinStrength: [LifeStep: Int] = [.fulLife: 50, .midLife: 65, .endLife: 85]
    
    /// Maximum strength of a weapon's type.
    static let swordMaxStrength: Int = 100
    
    
    
    // MARK: PowerStick (wizard's weapon)
    
    
    
    /// Name of weapon's type.
    static let powerstickName = "PowerStick"
    
    /// Minimum strength of a weapon's type regarding the life step of the future owner.
    static let powerstickMinStrength: [LifeStep: Int] = [.fulLife: 70, .midLife: 85, .endLife: 105]
    
    /// Maximum strength of a weapon's type.
    static let powerstickMaxStrength: Int = 120
    
    
    
    // MARK: HealthStick (druid's weapon)
    
    
    
    /// Name of weapon's type.
    static let healthstickName = "HealthStick"
    
    /// Minimum strength of a weapon's type regarding the life step of the future owner.
    static let healthstickMinStrength: [LifeStep: Int] = [.fulLife: 20, .midLife: 35, .endLife: 55]
    
    /// Maximum strength of a weapon's type.
    static let healthstickMaxStrength: Int = 70
    
    
    
    // MARK: Knife (joker's weapon)
    
    
    
    /// Name of weapon's type.
    static let knifeName = "Knife"
    
    /// Minimum strength of a weapon's type regarding the life step of the future owner.
    static let knifeMinStrength: [LifeStep: Int] = [.fulLife: 30, .midLife: 45, .endLife: 65]
    
    /// Maximum strength of a weapon's type.
    static let knifeMaxStrength: Int = 80
    
    
}
