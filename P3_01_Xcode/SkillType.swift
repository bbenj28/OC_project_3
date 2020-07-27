//
//  SkillType.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 27/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation
        // MARK: SkillsType

enum Skill { // the differents existing skills a character can use. All characters can use attack and heal, specialskill depends on its type.
    case attack
    case heal
    case multiAttack
    case multiHeal
    case diversion
    
    func name() -> String {
        switch self {
        case .attack:
            return "🗡 Attack"
        case .heal:
            return "🧪 Heal"
        case .multiAttack:
            return "⚔️ MultiAttack"
        case .multiHeal:
            return "💊 MultiHeal"
        case .diversion:
            return "🤡 Diversion"
        }
    }
    
    func description() -> String {
        switch self {
        case .multiAttack:
            return BACProperties.multiAttackDescription
        case .multiHeal:
            return BACProperties.multiHealDescription
        case .diversion:
            return BACProperties.diversionDescription
        default:
            return ""
        }
    }
}
