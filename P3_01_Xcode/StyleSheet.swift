//
//  StyleSheet.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 26/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation
class StyleSheet {
        // MARK: Titles stylesheet
    
    static func displayTitle(_ title: String) {
        // parameters
        displaySelectedTitle(
        title: title,
        maxDash: 70,
        dash: "=")
    }
    static func displaySubTitle(_ title: String) {
        // parameters
        displaySelectedTitle(
        title: title,
        maxDash: 60,
        dash: "*")
    }
    static func displayMiniTitle(_ title: String) {
        // parameters
        displaySelectedTitle(
            title: title,
            maxDash: 50,
            dash: "-")
    }
    static private func displaySelectedTitle(title: String, maxDash: Int, dash: String) {
        var text = "\n\n\n"
        if title.count > maxDash - 10 {
            print("Fatal Error : subtitle too long.")
            exit(0)
        }
        let dashCount: Int = (maxDash - title.count - 2) / 2
        // line
        for _ in 1...dashCount {
            text += dash
        }
        text += " \(title) "
        for _ in 1...dashCount {
            text += dash
        }
        if title.count + 2 + dashCount * 2 == maxDash - 1 {
            text += dash
        }
        // display
        print(text)
    }
    static func displayStarLine() {
        let maxDash = 50
        let dash = "-"
        var text = "\n"
        // line
        for _ in 1...maxDash {
            text += dash
        }
        // display
        print(text)
    }
}
