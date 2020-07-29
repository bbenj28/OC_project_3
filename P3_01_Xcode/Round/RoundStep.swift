//
//  RoundStep.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 27/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation

enum RoundStep {
    
    
    
    // enumerates the differents steps in a round
    case beginning
    case firstCharacterIsSelected
    case skillIsSelected
    case targetCharacterIsSelected
    case confirmedChoices
    
    
    
    
    /// Display title regarding active step.
    func displayTitle() {
        switch self {
        case .beginning:
            StyleSheet.displayMiniTitle("choose a character of yours")
        case .firstCharacterIsSelected:
            StyleSheet.displayMiniTitle("choose a skill")
        case .skillIsSelected:
            StyleSheet.displayMiniTitle("choose a target")
        case .targetCharacterIsSelected:
            StyleSheet.displayMiniTitle("CONFIRMATION")
        case .confirmedChoices:
            break
        }
    }
    
    /// Valid choice made by player by changing active step.
    func moveForward(_ hasToChooseTarget: Bool) -> RoundStep {
        switch self {
        case .beginning:
            return .firstCharacterIsSelected
        case .firstCharacterIsSelected:
            if hasToChooseTarget {
                return .skillIsSelected
            } else {
                return .targetCharacterIsSelected
            }
        case .skillIsSelected:
            return .targetCharacterIsSelected
        case .targetCharacterIsSelected, .confirmedChoices:
            return .confirmedChoices
        }
    }
    
    /// Cancel last choice made by player by changing active step.
    func cancelLastChoice(_ hasToChooseTarget: Bool) -> RoundStep {
        switch self {
        case .beginning, .firstCharacterIsSelected:
            return .beginning
        case .skillIsSelected:
            return .firstCharacterIsSelected
        case .targetCharacterIsSelected:
            if hasToChooseTarget {
                return .skillIsSelected
            } else {
                return .firstCharacterIsSelected
            }
        case .confirmedChoices:
            return .skillIsSelected
        }
    }
    
    
}
