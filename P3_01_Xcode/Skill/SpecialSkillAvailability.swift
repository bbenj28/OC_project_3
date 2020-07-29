//
//  SpecialSkillAvailability.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 27/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation

enum SpecialSkillAvailability: String {
    // is the special skill of a character available ?
    case available = ""
    case used = "[used]"
    case unavailable = "[unavailable, used last round]"
}
