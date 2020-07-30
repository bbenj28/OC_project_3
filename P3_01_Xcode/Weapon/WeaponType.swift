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
        switch self {
        case .sword:
            return BACProperties.swordName
        case .powerStick:
            return BACProperties.powerstickName
        case .healthStick:
            return BACProperties.healthstickName
        case .knife:
            return BACProperties.knifeName
        }
    }

    /// Ask the weapon's type's minimum strength.
    /// - parameter lifeStep : The character's life step.
    /// - returns: The weapon's type's minimum strength.
    func minStrength(_ lifeStep: LifeStep) -> Int {
        let optionalMin: Int?
        switch self {
        case .sword:
            optionalMin = BACProperties.swordMinStrength[lifeStep]
        case .powerStick:
            optionalMin = BACProperties.powerstickMinStrength[lifeStep]
        case .healthStick:
            optionalMin = BACProperties.healthstickMinStrength[lifeStep]
        case .knife:
            optionalMin = BACProperties.knifeMinStrength[lifeStep]
        }
        guard let minStrength = optionalMin else {
            print("Fatal Error : minimum strength for choosen lifestep returns nil.")
            exit(0)
        }
        return minStrength
    }

    /// Ask the weapon's type's maximum strength.
    /// - returns: The weapon's type's maximum strength.
    func maxStrength() -> Int {
        switch self {
        case .sword:
            return BACProperties.swordMaxStrength
        case .powerStick:
            return BACProperties.powerstickMaxStrength
        case .healthStick:
            return BACProperties.healthstickMaxStrength
        case .knife:
            return BACProperties.knifeMaxStrength
        }
    }
}
