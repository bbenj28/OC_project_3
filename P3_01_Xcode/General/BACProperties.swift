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
    
    //MARK: Game
    // strength and healthcare explanations
    static let strengthExplanations = "\n✧ Strength : when a character attacks another, this target receive injuries points. Injuries points are at least a half of the offenser's strength. The character's strength depends on its weapon's. The PowerSticks of the wizards have the highest strength potential. However, if the character is diverted by a joker, its strength is multiplied by a coefficient between 0 and 0.5, which change all the time. \n value = weapon's strength × diversion's coefficient."
    static let healthcareExplanations = "\n✧ Healthcare's capability : when a character heals another, this target receives heal points. Heal points are at least a half of the healer's healthcare's capability. The character's healthcare's capability depends on its strength and its healthcare coefficient. This coefficient depends on the character's type. Druids have the highest healthcare coefficient. \n value = character's strength × healthcare coefficient\n"
    
    
    // MARK: Chest
    // chances to get a chest at the round's end
    static let chestChances = 4
    
    
    // MARK: Specialskills
    static let isSpecialSkillEnabled = true
    static let specialSkillExplanations = "\n✧ Special skill : each character has a special skill. This skill depends on the character's type. If a character use its special skill, it can not use it the next round."
    static let multiAttackDescription = "Their specialskill allows them to attack several enemies with one action."
    static let multiHealDescription = "Their specialskill allows them to heal several allies with one action."
    static let diversionDescription = "Their specialskill allows them to distract an enemy during several rounds."
    static let diversionMaxRound = 4
    
    
    // MARK: Characters Types
    
    
    
            // MARK: Warrior
    
    static let warriorName = "Warrior"
    static let warriorInitials = "[Wa]"
    static let warriorEmoticon = "💂"
    static let warriorDescription = "The strongest recruit you will see. Warriors are naturally born to kill. They are the most resistants soldiers and their strength will cause many damages."
    static let warriorMaxHealthPoints: Int = 300
    static let warriorHealthCareCoefficient: Double = 0.2
    static let warriorSpecialSkill: Skill = .multiAttack
    static let warriorWeaponType: WeaponType = .sword
    
            // MARK: Wizard
    static let wizardName = "Wizard"
    static let wizardInitials = "[Wi]"
    static let wizardEmoticon = "🧙"
    static let wizardDescription = "Beware! Behind their frail appearance, the witchers are no less formidable. They aren't very resistants, but their PowerStick gives them great strength."
    static let wizardMaxHealthPoints: Int = 150
    static let wizardHealthCareCoefficient: Double = 0.3
    static let wizardSpecialSkill: Skill = .multiAttack
    static let wizardWeaponType: WeaponType = .powerStick
    
            // MARK: Druid
    static let druidName = "Druid"
    static let druidInitials = "[Dr]"
    static let druidEmoticon = "🧑‍⚕️"
    static let druidDescription = "In communion with nature and their environment, druids are pleased to take care of others. Their ability to heal is second to none."
    static let druidMaxHealthPoints: Int = 150
    static let druidHealthCareCoefficient: Double = 2
    static let druidSpecialSkill: Skill = .multiHeal
    static let druidWeaponType: WeaponType = .healthStick
    
            // MARK: Joker
    static let jokerName = "Joker"
    static let jokerInitials = "[Jo]"
    static let jokerEmoticon = "🃏"
    static let jokerDescription = "Not really resistant, not strong either and without healing power, jokers can nevertheless, through their humor, distract enemies and give you an advantage."
    static let jokerMaxHealthPoints: Int = 200
    static let jokerHealthCareCoefficient: Double = 0.5
    static let jokerSpecialSkill: Skill = .diversion
    static let jokerWeaponType: WeaponType = .knife
    
    
    // MARK: Weapons
    static let areLifeStepsUseFull: Bool = true
    
    
            // MARK: Sword (warrior's weapon)
    static let swordName = "Sword"
    static let swordMinStrength: [LifeStep: Int] = [.fulLife: 50, .midLife: 65, .endLife: 85]
    static let swordMaxStrength: Int = 100
    
            // MARK: PowerStick (wizard's weapon)
    static let powerstickName = "PowerStick"
    static let powerstickMinStrength: [LifeStep: Int] = [.fulLife: 70, .midLife: 85, .endLife: 105]
    static let powerstickMaxStrength: Int = 120
    
            // MARK: HealthStick (druid's weapon)
    static let healthstickName = "HealthStick"
    static let healthstickMinStrength: [LifeStep: Int] = [.fulLife: 20, .midLife: 35, .endLife: 55]
    static let healthstickMaxStrength: Int = 70
    
            // MARK: Knife (joker's weapon)
    static let knifeName = "Knife"
    static let knifeMinStrength: [LifeStep: Int] = [.fulLife: 30, .midLife: 45, .endLife: 65]
    static let knifeMaxStrength: Int = 80
    
    
}
