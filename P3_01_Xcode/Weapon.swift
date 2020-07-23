//
//  Weapon.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

// MARK: Weapon

class Weapon {
    
        // MARK: Properties
    let strength: Int // weapon's strength
    let name: String // weapon's name
    let type: WeaponType // weapon's type
    
        // MARK: Init
    init(type: WeaponType, name: String, strength: Int) {
        self.type = type
        self.name = name
        self.strength = strength
    }
}


// MARK: Weapon's class inheritance
// creation of classes which inherit from Weapon : all classes are developed the same way. The first is commented, but the comments can be applied on all of them


    // MARK: Sword
class Sword: Weapon { // warrior's weapon
    init(firstWeapon: Bool, lifeStep: LifeSteps) {
        // get minimum strength possibilities in bacproperties
        guard let minStrengthForChoosenLifeStep = bacproperties.swordMinStrength[lifeStep] else {
            print("Fatal Error : sword's minimum strength for choosen lifestep returns nil.")
            exit(0)
        }
        guard let minStrengthForFullLifeStep = bacproperties.swordMinStrength[.fulLife] else {
            print("Fatal Error : sword's minimum strength for full lifestep returns nil.")
            exit(0)
        }
        // returns the weapon's minimum strength according to the possibility of modifying it on the basis of the character's life expectancy
        let minStrength: Int
        if bacproperties.areLifeStepsUseFull {
            minStrength = minStrengthForChoosenLifeStep
        } else {
            minStrength = minStrengthForFullLifeStep
        }
        // returns the weapon's maximum strength
        let maxStrength: Int = bacproperties.swordMaxStrength
        let strength: Int
        // returns the weapon's strength by choosen a number between the minimum and the maximum. If this weapon is the character's first, returns minimum strength + 1
        if firstWeapon {
            strength = minStrength + 1
        } else {
            strength = Int.random(in: minStrength...maxStrength)
        }
        // returns the name of the weapon. Its name is based on its strength.
        let name: String
        let thirdDifferenceStrength: Int = (bacproperties.swordMaxStrength - minStrengthForFullLifeStep) / 3
        switch strength {
        case let x where x < minStrength + thirdDifferenceStrength:
            name = "Rookie " + bacproperties.swordName
        case let x where x > maxStrength - thirdDifferenceStrength:
            name = "Killer " + bacproperties.swordName
        default:
            name = "Regular " + bacproperties.swordName
        }
        // weapon initialisation
        super.init(type: .sword, name: name, strength: strength)
    }
}

        // MARK: PowerStick
class PowerStick: Weapon { // wizard's weapon
    init(firstWeapon: Bool, lifeStep: LifeSteps) {
        guard let minStrengthForChoosenLifeStep = bacproperties.powerstickMinStrength[lifeStep] else {
            print("Fatal Error : powerstick's minimum strength for choosen lifestep returns nil.")
            exit(0)
        }
        guard let minStrengthForFullLifeStep = bacproperties.powerstickMinStrength[.fulLife] else {
            print("Fatal Error : powerstick's minimum strength for full lifestep returns nil.")
            exit(0)
        }
        let minStrength: Int
        if bacproperties.areLifeStepsUseFull {
            minStrength = minStrengthForChoosenLifeStep
        } else {
            minStrength = minStrengthForFullLifeStep
        }
        let maxStrength: Int = bacproperties.powerstickMaxStrength
        let strength: Int
        if firstWeapon {
            strength = minStrength
        } else {
            strength = Int.random(in: minStrength...maxStrength)
        }
        let name: String
        let thirdDifferenceStrength: Int = (bacproperties.powerstickMaxStrength - minStrengthForFullLifeStep) / 3
        switch strength {
        case let x where x < minStrength + thirdDifferenceStrength:
            name = "Rookie " + bacproperties.powerstickName
        case let x where x > maxStrength - thirdDifferenceStrength:
            name = "Killer " + bacproperties.powerstickName
        default:
            name = "Regular " + bacproperties.powerstickName
        }
        super.init(type: .powerStick, name: name, strength: strength)
    }
}

        // MARK: HealthStick
class HealthStick: Weapon { // druid's weapon
    init(firstWeapon: Bool, lifeStep: LifeSteps) {
        guard let minStrengthForChoosenLifeStep = bacproperties.healthstickMinStrength[lifeStep] else {
            print("Fatal Error : healthstick's minimum strength for choosen lifestep returns nil.")
            exit(0)
        }
        guard let minStrengthForFullLifeStep = bacproperties.healthstickMinStrength[.fulLife] else {
            print("Fatal Error : healthstick's minimum strength for full lifestep returns nil.")
            exit(0)
        }
        let minStrength: Int
        if bacproperties.areLifeStepsUseFull {
            minStrength = minStrengthForChoosenLifeStep
        } else {
            minStrength = minStrengthForFullLifeStep
        }
        let maxStrength: Int = bacproperties.healthstickMaxStrength
        let strength: Int
        if firstWeapon {
            strength = minStrength
        } else {
            strength = Int.random(in: minStrength...maxStrength)
        }
        let name: String
        let thirdDifferenceStrength: Int = (bacproperties.healthstickMaxStrength - bacproperties.healthstickMinStrength[.fulLife]!) / 3
        switch strength {
        case let x where x < minStrength + thirdDifferenceStrength:
            name = "Rookie " + bacproperties.healthstickName
        case let x where x > maxStrength - thirdDifferenceStrength:
            name = "Killer " + bacproperties.healthstickName
        default:
            name = "Regular " + bacproperties.healthstickName
        }
        super.init(type: .healthStick, name: name, strength: strength)
    }
}

        // MARK: Knife
class Knife: Weapon { // joker's weapon
    init(firstWeapon: Bool, lifeStep: LifeSteps) {
        guard let minStrengthForChoosenLifeStep = bacproperties.knifeMinStrength[lifeStep] else {
            print("Fatal Error : knife's minimum strength for choosen lifestep returns nil.")
            exit(0)
        }
        guard let minStrengthForFullLifeStep = bacproperties.knifeMinStrength[.fulLife] else {
            print("Fatal Error : knife's minimum strength for full lifestep returns nil.")
            exit(0)
        }
        let minStrength: Int
        if bacproperties.areLifeStepsUseFull {
            minStrength = minStrengthForChoosenLifeStep
        } else {
            minStrength = minStrengthForFullLifeStep
        }
        let maxStrength: Int = bacproperties.knifeMaxStrength
        let strength: Int
        if firstWeapon {
            strength = minStrength
        } else {
            strength = Int.random(in: minStrength...maxStrength)
        }
        let name: String
        let thirdDifferenceStrength: Int = (bacproperties.knifeMaxStrength - bacproperties.knifeMinStrength[.fulLife]!) / 3
        switch strength {
        case let x where x < minStrength + thirdDifferenceStrength:
            name = "Rookie " + bacproperties.knifeName
        case let x where x > maxStrength - thirdDifferenceStrength:
            name = "Killer " + bacproperties.knifeName
        default:
            name = "Regular " + bacproperties.knifeName
        }
        super.init(type: .knife, name: name, strength: strength)
    }
}



// MARK: Enumeration based on weapon's properties



        // MARK: WeaponType

enum WeaponType {
    // enumerates the weapon's types
    case sword // for warriors
    case powerStick // for wizards
    case healthStick // for druids
    case knife // for jokers
}


