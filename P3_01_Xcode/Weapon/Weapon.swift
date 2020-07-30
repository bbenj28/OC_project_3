//
//  Weapon.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

class Weapon {
    
    // MARK: - Properties
    
    /// Weapon's name.
    let name: String
    
    /// Weapon's strength.
    let strength: Int
    
    // MARK: - Init
    
    init(type: WeaponType, firstWeapon: Bool, lifeStep: LifeStep) {
        // get the weapon's minimum strength according to the possibility of modifying it on the basis of the character's life expectancy
        let minStrength: Int
        if BACProperties.areLifeStepsUseFull {
            minStrength = type.minStrength(lifeStep)
        } else {
            minStrength = type.minStrength(.fulLife)
        }
        // get the weapon's maximum strength
        let maxStrength: Int = type.maxStrength()
        let strength: Int
        if firstWeapon {
            // If this weapon is the character's first, strength equals minimum strength + 1
            strength = minStrength + 1
        } else {
            // otherwise, get the weapon's strength by choosen a number between the minimum and the maximum.
            strength = Int.random(in: minStrength...maxStrength)
        }
        // get the name of the weapon. Its name is based on its strength.
        let name: String
        let thirdDifferenceStrength: Int = (maxStrength - type.minStrength(.fulLife)) / 3
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
