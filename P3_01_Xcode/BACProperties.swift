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
    
    // MARK: Chest
    // chances to get a chest at the round's end
    let chestChances = 4
    
    
    // MARK: Specialskills
    let isSpecialSkillEnabled = true
    let multiAttackDescription = "Their specialskill allows them to attack several enemies with one action."
    let multiHealDescription = "Their specialskill allows them to heal several allies with one action."
    let diversionDescription = "Their specialskill allows them to distract an enemy during several rounds."
    
    
    // MARK: Characters Types
    
    
    
            // MARK: Warrior
    
    let warriorName = "Warrior"
    let warriorInitials = "[Wa]"
    let warriorEmoticon = "💂"
    let warriorDescription = "The strongest recruit you will see. Warriors are naturally born to kill. They are the most resistants soldiers and their strength will cause many damages."
    let warriorMaxHealthPoints: Int = 300
    let warriorHealthCareCoefficient: Double = 0.5
    let warriorSpecialSkill: SkillsType = .multiAttack
    
            // MARK: Wizard
    let wizardName = "Wizard"
    let wizardInitials = "[Wi]"
    let wizardEmoticon = "🧙"
    let wizardDescription = "Beware! Behind their frail appearance, the witchers are no less formidable. They aren't very resistants, but their PowerStick gives them great strength."
    let wizardMaxHealthPoints: Int = 150
    let wizardHealthCareCoefficient: Double = 0.2
    let wizardSpecialSkill: SkillsType = .multiAttack
    
            // MARK: Druid
    let druidName = "Druid"
    let druidInitials = "[Dr]"
    let druidEmoticon = "🧑‍⚕️"
    let druidDescription = "In communion with nature and their environment, druids are pleased to take care of others. Their ability to heal is second to none."
    let druidMaxHealthPoints: Int = 200
    let druidHealthCareCoefficient: Double = 1.5
    let druidSpecialSkill: SkillsType = .multiHeal
    
            // MARK: Joker
    let jokerName = "Joker"
    let jokerInitials = "[Jo]"
    let jokerEmoticon = "🃏"
    let jokerDescription = "Not really resistant, not strong either and without healing power, jokers can nevertheless, through their humor, distract enemies and give you an advantage."
    let jokerMaxHealthPoints: Int = 200
    let jokerHealthCareCoefficient: Double = 0.7
    let jokerSpecialSkill: SkillsType = .diversion
    
    
    // MARK: Weapons
    let areLifeStepsUseFull: Bool = true
    
    
            // MARK: Sword (warrior's weapon)
    let swordName = "Sword"
    let swordMinStrength: [LifeSteps: Int] = [.fulLife: 50, .midLife: 65, .endLife: 85]
    let swordMaxStrength: Int = 100
    
            // MARK: PowerStick (wizard's weapon)
    let powerstickName = "PowerStick"
    let powerstickMinStrength: [LifeSteps: Int] = [.fulLife: 70, .midLife: 85, .endLife: 105]
    let powerstickMaxStrength: Int = 120
    
            // MARK: HealthStick (druid's weapon)
    let healthstickName = "HealthStick"
    let healthstickMinStrength: [LifeSteps: Int] = [.fulLife: 30, .midLife: 45, .endLife: 65]
    let healthstickMaxStrength: Int = 80
    
            // MARK: Knife (joker's weapon)
    let knifeName = "Knife"
    let knifeMinStrength: [LifeSteps: Int] = [.fulLife: 30, .midLife: 45, .endLife: 65]
    let knifeMaxStrength: Int = 80
    
    
}

// MARK: Instantiation
let bacproperties = BACProperties()
