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
    let emoticon: String // emoticon of the character's type, example : 💂 for Warrior
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
        return diversionRounds != nil
    }
    var specialSkillIsAvailable: SpecialSkillAvailability = .available
    
        // MARK: Init
    init(name: String, type: CharacterType, weapon: Weapon, specialSkill: SkillsType, healthCareCoefficient: Double, initials: String, maxHealthPoints: Int, emoticon: String) {
        self.name = name
        self.type = type
        self.weapon = weapon
        self.skills = [.attack, .heal, specialSkill] // all characters can use attack and heal, specialskill depends on its type
        self.healthCareCoefficient = healthCareCoefficient
        self.initials = initials
        self.maxHealthPoints = maxHealthPoints
        self.emoticon = emoticon
    }
    
        // MARK: Methods
    func attack(_ target: Character) {
        // chooses a random number between strength / 2 and strength, and substracts this number to the target healthpoints
        var injuriesPoints = Int.random(in: strength/2...strength)
        if injuriesPoints > target.healthPoints {
            injuriesPoints = target.healthPoints
        }
        target.injuriesPoints += injuriesPoints
        print("Sustained injuries points : \(injuriesPoints)")
        if target.isDead {
            print("🎖 \(target.name) died ! 💀")
        }
    }
    func heal(_ target: Character) {
        // checks if healthcare points + target's healthpoints are less than the maximum healthpoints, and add healthcare points to the target healthpoints
        var healPoints: Int = healthCare
        if healPoints + target.healthPoints > target.maxHealthPoints {
            healPoints = target.maxHealthPoints - target.healthPoints
        }
        target.healPoints += healPoints
        print("Received heal points : \(healPoints)")
    }
    func multiAttack(_ player: Player) {
        // chooses a random number between strength / 2 and strength, and substract a third of this number to the healthpoints of each alive character of the choosenplayer
        let injuriesPoints = Int.random(in: strength/2...strength)
        let characters = [Player.characters[player.index * 3], Player.characters[player.index * 3 + 1], Player.characters[player.index * 3 + 2]]
        for target in characters {
            if target.isDead == false {
                var thirdInjuriesPoints = injuriesPoints / 3
                if thirdInjuriesPoints > target.healthPoints {
                    thirdInjuriesPoints = target.healthPoints
                }
                target.injuriesPoints += thirdInjuriesPoints
                print("Sustained injuries points : \(thirdInjuriesPoints) for \(target.name)")
                if target.isDead {
                    print("🎖 \(target.name) died ! 💀")
                }
            }
        }
        
        // special skill is used, next round this character won't be able to use it again
        specialSkillIsUsed()
    }
    func multiHeal(_ player: Player) {
        // for each alive character of the choosenplayer, checks if a third of healthcare points + target's healthpoints are less than its maximum healthpoints, and add a third of healthcare points to the target healthpoints
        let thirdHealthCare: Int = healthCare / 3
        let characters = [Player.characters[player.index * 3], Player.characters[player.index * 3 + 1], Player.characters[player.index * 3 + 2]]
        for target in characters {
            var healPoints: Int = thirdHealthCare
            if target.isDead == false {
                if healPoints + target.healthPoints > target.maxHealthPoints {
                    healPoints = target.maxHealthPoints - target.healthPoints
                }
                target.healPoints += healPoints
                print("Received heal points : \(healPoints) for \(target.name)")
            }
        }
        // special skill is used, next round this character won't be able to use it again
        specialSkillIsUsed()
    }
    func diversion(_ target: Character) {
        // chooses a random number of rounds during which the target will be diverted
        let randomRounds: Int = Int.random(in: 2...4)
        target.diversionRounds = randomRounds
        print("\(target.name) is diverted for \(randomRounds) rounds.")
        // special skill is used, next round this character won't be able to use it again
        specialSkillIsUsed()
    }
 
    private func specialSkillIsUsed() {
        //switch special skill availability to used. Next round, the special skill will be unavailable
        specialSkillIsAvailable = .used
    }
    
    /// Display informations about the character.
    /// - parameter full : Return full informations of the character.
    /// - parameter evenDead : Return character's informations, even if the character is dead.
    /// - returns: Character's informations or nil if the character is dead.
    func informations(full: Bool, evenDead: Bool) -> String? {
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
            emoticon = "🤪 "
        } else if isDead {
            emoticon = "💀 "
        } else {
            emoticon = self.emoticon
        }
        if full {
            if evenDead || !isDead {
                guard let index = preIndex else {
                    print("Fatal Error : character not found in Player.characters.")
                    exit(0)
                }
                return "\(index + 1). \(initials) \(emoticon) \(name) : [Str. \(strength)] [HP \(healthPoints)/\(maxHealthPoints)]"
            }
        } else {
            if evenDead || !isDead {
                return "\(initials) \(emoticon) \(name)"
            }
        }
        return nil
    }
}
     


// MARK: Character's class inheritance


        // MARK: Warrior
class Warrior: Character {
    init(name: String, weapon: Weapon) {
        super.init(name: name,
                   type: .warrior,
                   weapon: weapon,
                   specialSkill: bacproperties.warriorSpecialSkill,
                   healthCareCoefficient: bacproperties.warriorHealthCareCoefficient,
                   initials: bacproperties.warriorInitials,
                   maxHealthPoints: bacproperties.warriorMaxHealthPoints,
                   emoticon: bacproperties.warriorEmoticon)
    }
}

        // MARK: Wizard
class Wizard: Character {
    init(name: String, weapon: Weapon) {
        super.init(name: name,
                   type: .wizard,
                   weapon: weapon,
                   specialSkill: bacproperties.wizardSpecialSkill,
                   healthCareCoefficient: bacproperties.wizardHealthCareCoefficient,
                   initials: bacproperties.wizardInitials,
                   maxHealthPoints: bacproperties.wizardMaxHealthPoints,
                   emoticon: bacproperties.wizardEmoticon)
    }
}

        // MARK: Druid
class Druid: Character {
    init(name: String, weapon: Weapon) {
        super.init(name: name,
                   type: .druid,
                   weapon: weapon,
                   specialSkill: bacproperties.druidSpecialSkill,
                   healthCareCoefficient: bacproperties.druidHealthCareCoefficient,
                   initials: bacproperties.druidInitials,
                   maxHealthPoints: bacproperties.druidMaxHealthPoints,
                   emoticon: bacproperties.druidEmoticon)
    }
}

        // MARK: Joker
class Joker: Character {
    init(name: String, weapon: Weapon) {
        super.init(name: name,
                   type: .joker,
                   weapon: weapon,
                   specialSkill: bacproperties.jokerSpecialSkill,
                   healthCareCoefficient: bacproperties.jokerHealthCareCoefficient,
                   initials: bacproperties.jokerInitials,
                   maxHealthPoints: bacproperties.jokerMaxHealthPoints,
                   emoticon: bacproperties.jokerEmoticon)
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
    case attack = "🗡 Attack"
    case heal = "🧪 Heal"
    case multiAttack = "⚔️ MultiAttack"
    case multiHeal = "💊 MultiHeal"
    case diversion = "🤡 Diversion"
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

