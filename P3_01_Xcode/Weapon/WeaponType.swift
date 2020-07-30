//
//  WeaponType.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 27/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation

enum WeaponType {

    // enumerates the weapon's types
    case sword // for warriors
    case powerStick // for wizards
    case healthStick // for druids
    case knife // for jokers

    // MARK: - Informations

    /// Ask the weapon's type's name.
    /// - returns: The weapon's type's name.
    func name() -> String {
        guard let name = BACProperties.weaponsTypeName[self] else {
            print("Fatal Error : Weapon's type's name returns nil.")
            exit(0)
        }
        return name
    }

    /// Ask the weapon's type's minimum strength.
    /// - parameter lifeStep : The character's life step.
    /// - returns: The weapon's type's minimum strength.
    func minStrength(_ lifeStep: LifeStep) -> Int {
        guard let optionalMin = BACProperties.weaponsTypeMinStrength[self] else {
            print("Fatal Error : Weapon's type's minimum strength returns nil.")
            exit(0)
        }
        guard let minStrength = optionalMin[lifeStep] else {
            print("Fatal Error : minimum strength for choosen lifestep returns nil.")
            exit(0)
        }
        return minStrength
    }

    /// Ask the weapon's type's maximum strength.
    /// - returns: The weapon's type's maximum strength.
    func maxStrength() -> Int {
        guard let maxStrength = BACProperties.weaponsTypeMaxStrength[self] else {
            print("Fatal Error : Weapon's type's name returns nil.")
            exit(0)
        }
        return maxStrength
    }
}
