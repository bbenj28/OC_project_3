//
//  Character.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

// MARK: Character

class Character {
    
        // MARK: Properties
    let name: String // name of the character
    let initials: String // intitals of the character's type, example : Wa for Warrior
    let type: CharacterType // type of the character
    let maxHealthPoints: Int // the maximum healthpoints the character can have
    var healthPoints: Int { // computes the healthpoints the character actually have
        return maxHealthPoints - injuriesPoints + healPoints
    }
    var injuriesPoints: Int = 0 // injuries points suffered by the character
    var healPoints: Int = 0 // heal points getted by the character
    var activeStep: LifeSteps { // based on its healthpoints, is the character dying ?
        switch healthPoints {
        case maxHealthPoints:
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
    let healthCareCoefficient: Double // coefficient will serve to compute the healthcare
    var healthCare: Int {
        //healthCare of the character depends on his strength and his healthcare coefficient.
        return Int(Double(strength) * healthCareCoefficient)
    }
    var weapon: Weapon // weapon of the character
    let skills: [SkillsType] // skills of the character
    var diversionRounds: Int? // if the character suffers of diversion, for how many rounds ?
    var isDiverted: Bool{
        //Characters could be diverted by a joker. The diversion can last up to 4 rounds. This computed variable check if the character is still diverted.
        if let _ = diversionRounds{
            return true
        } else {
            return false
        }
    }
    var specialSkillIsAvailable: SpecialSkillAvailability = .available
    
        // MARK: Init
    init(name: String, type: CharacterType, weapon: Weapon, specialSkill: SkillsType, healthCareCoefficient: Double, initials: String, maxHealthPoints: Int) {
        self.name = name
        self.type = type
        self.weapon = weapon
        self.skills = [.attack, .heal, specialSkill] // all characters can use attack and heal, specialskill depends on its type
        self.healthCareCoefficient = healthCareCoefficient
        self.initials = initials
        self.maxHealthPoints = maxHealthPoints
    }
    
        // MARK: Methods
    func attack(_ target: Character) {
        // chooses a random number between strength / 2 and strength, and substracts this number to the target healthpoints
        var attackCoefficient = Int.random(in: strength/2...strength)
        if attackCoefficient > target.healthPoints {
            attackCoefficient = target.healthPoints
        }
        target.injuriesPoints += attackCoefficient
    }
    func heal(_ target: Character) {
        // checks if healthcare points + target's healthpoints are less than the maximum healthpoints, and add healthcare points to the target healthpoints
        var healPointsToAdd: Int = healthCare
        if healPointsToAdd + target.healthPoints > target.maxHealthPoints {
            healPointsToAdd = target.maxHealthPoints - target.healthPoints
        }
        target.healPoints += healPointsToAdd
    }
    
    // à bouger dans les classes filles
    func multiAttack(_ player: Player) {
        // chooses a random number between strength / 2 and strength, and substract a third of this number to the healthpoints of each alive character of the choosenplayer
        let attackCoefficient = Int.random(in: strength/2...strength)
        for target in player.characters {
            if target.isDead == false {
                var thirdAttackCoefficient = attackCoefficient / 3
                if thirdAttackCoefficient > target.healthPoints {
                    thirdAttackCoefficient = target.healthPoints
                }
                target.injuriesPoints += thirdAttackCoefficient
            }
        }
        // special skill is used, next round this character won't be able to use it again
        specialSkillIsUsed()
    }
    func multiHeal(_ player: Player) {
        // for each alive character of the choosenplayer, checks if a third of healthcare points + target's healthpoints are less than its maximum healthpoints, and add a third of healthcare points to the target healthpoints
        let thirdHealthCare: Int = healthCare / 3
        for target in player.characters {
            var healPointsToAdd: Int = thirdHealthCare
            if target.isDead == false {
                if healPointsToAdd + target.healthPoints > target.maxHealthPoints {
                    healPointsToAdd = target.maxHealthPoints - target.healthPoints
                }
                target.healPoints += healPointsToAdd
            }
        }
        // special skill is used, next round this character won't be able to use it again
        specialSkillIsUsed()
    }
    func diversion(_ target: Character) {
        // chooses a random number of rounds during which the target will be diverted
        let randomRounds: Int = Int.random(in: 2...4)
        target.diversionRounds = randomRounds
        // special skill is used, next round this character won't be able to use it again
        specialSkillIsUsed()
    }
    private func specialSkillIsUsed() {
        //switch special skill availability to used. Next round, the special skill will be unavailable
        specialSkillIsAvailable = .used
    }
}


// MARK: Character's class inheritance
// creation of classes which inherit from Character : all classes are developed the same way. The first is commented, but the comments can be applied on all of them


        // MARK: Warrior
class Warrior: Character {
    init(name: String, weapon: Weapon) {
        let specialSkill = bacproperties.warriorSpecialSkill // specialskill which can be used by the character type
        let healthCareCoefficient = bacproperties.warriorHealthCareCoefficient // healthcare coefficient of the character type
        let initials = bacproperties.warriorInitials // initials of the character type
        let maxHealthPoints = bacproperties.warriorMaxHealthPoints // maximum healthpoints a character of this type can have
        super.init(name: name, type: .warrior, weapon: weapon, specialSkill: specialSkill, healthCareCoefficient: healthCareCoefficient, initials: initials, maxHealthPoints: maxHealthPoints)
    }
}

        // MARK: Wizard
class Wizard: Character {
    init(name: String, weapon: Weapon) {
        let specialSkill = bacproperties.wizardSpecialSkill
        let healthCareCoefficient = bacproperties.wizardHealthCareCoefficient
        let initials = bacproperties.wizardInitials
        let maxHealthPoints = bacproperties.wizardMaxHealthPoints
        super.init(name: name, type: .wizard, weapon: weapon, specialSkill: specialSkill, healthCareCoefficient: healthCareCoefficient, initials: initials, maxHealthPoints: maxHealthPoints)
    }
}

        // MARK: Druid
class Druid: Character {
    init(name: String, weapon: Weapon) {
        let specialSkill = bacproperties.druidSpecialSkill
        let healthCareCoefficient = bacproperties.druidHealthCareCoefficient
        let initials = bacproperties.druidInitials
        let maxHealthPoints = bacproperties.druidMaxHealthPoints
        super.init(name: name, type: .druid, weapon: weapon, specialSkill: specialSkill, healthCareCoefficient: healthCareCoefficient, initials: initials, maxHealthPoints: maxHealthPoints)
    }
}

        // MARK: Joker
class Joker: Character {
    init(name: String, weapon: Weapon) {
        let specialSkill = bacproperties.jokerSpecialSkill
        let healthCareCoefficient = bacproperties.jokerHealthCareCoefficient
        let initials = bacproperties.jokerInitials
        let maxHealthPoints = bacproperties.jokerMaxHealthPoints
        super.init(name: name, type: .joker, weapon: weapon, specialSkill: specialSkill, healthCareCoefficient: healthCareCoefficient, initials: initials, maxHealthPoints: maxHealthPoints)
    }
}



// MARK: Enumerations based on character's properties



        // MARK: LifeSteps

enum LifeSteps { // is the character dying ?
    case fulLife
    case midLife
    case endLife
}

        // MARK: SkillsType

enum SkillsType: String { // the differents existing skills a character can use. All characters can use attack and heal, specialskill depends on its type.
    case attack = "Attack"
    case heal = "Heal"
    case multiAttack = "MultiAttack"
    case multiHeal = "MultiHeal"
    case diversion = "Diversion"
}

        // MARK: CharacterType

enum CharacterType { // the differents types of a character
    case warrior
    case wizard
    case druid
    case joker
}

        // MARK: SpecialSkillAvailability

enum SpecialSkillAvailability { // is the special skill of a character available ?
    case available
    case used
    case unavailable
}

