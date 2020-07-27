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
    
    
}
