//
//  Weapon.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

class Weapon {
    
    
    
        // MARK: Properties
    
    
    
    let strength: Int // weapon's strength
    let name: String // weapon's name
    let type: WeaponType // weapon's type
    
    
    
        // MARK: Init
    
    
    
    init(type: WeaponType, firstWeapon: Bool, lifeStep: LifeStep) {
        self.type = type
        let minStrengthForChoosenLifeStep = type.minStrength(lifeStep)
        let minStrengthForFullLifeStep = type.minStrength(.fulLife)
        // returns the weapon's minimum strength according to the possibility of modifying it on the basis of the character's life expectancy
        let minStrength: Int
        if BACProperties.areLifeStepsUseFull {
            minStrength = minStrengthForChoosenLifeStep
        } else {
            minStrength = minStrengthForFullLifeStep
        }
        // returns the weapon's maximum strength
        let maxStrength: Int = type.maxStrength()
        let strength: Int
        // returns the weapon's strength by choosen a number between the minimum and the maximum. If this weapon is the character's first, returns minimum strength + 1
        if firstWeapon {
            strength = minStrength + 1
        } else {
            strength = Int.random(in: minStrength...maxStrength)
        }
        // returns the name of the weapon. Its name is based on its strength.
        let name: String
        let thirdDifferenceStrength: Int = (maxStrength - minStrengthForFullLifeStep) / 3
        switch strength {
        case let x where x < minStrength + thirdDifferenceStrength:
            name = "Rookie \(type.name())"
        case let x where x > maxStrength - thirdDifferenceStrength:
            name = "Killer \(type.name())"
        default:
            name = "Regular \(type.name())"
        }
        self.name = name
        self.strength = strength
    }
}
