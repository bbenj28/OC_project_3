//
//  StyleSheet.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 26/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation

class StyleSheet {

    /// Display title.
    /// - parameter title: Title to display.
    static func displayTitle(_ title: String) {
        // parameters
        displaySelectedTitle(
        title: title,
        maxSigns: 70,
        sign: "=")
    }

    /// Display subtitle.
    /// - parameter title: Subtitle to display.
    static func displaySubTitle(_ title: String) {
        // parameters
        displaySelectedTitle(
        title: title,
        maxSigns: 60,
        sign: "*")
    }

    /// Display mini title.
    /// - parameter title: Mini title to display.
    static func displayMiniTitle(_ title: String) {
        // parameters
        displaySelectedTitle(
            title: title,
            maxSigns: 50,
            sign: "-")
    }

    /// Display title with title's style's signs.
    /// - parameter title: Title to display.
    /// - parameter maxSigns : Length of the title with signs.
    /// - parameter sign : Type of signs.
    static private func displaySelectedTitle(title: String, maxSigns: Int, sign: String) {
        var text = "\n\n\n"
        if title.count > maxSigns - 10 {
            print("Fatal Error : title too long.")
            exit(0)
        }
        let signsCount: Int = (maxSigns - title.count - 2) / 2
        // line
        for _ in 1...signsCount {
            text += sign
        }
        text += " \(title) "
        for _ in 1...signsCount {
            text += sign
        }
        if title.count + 2 + signsCount * 2 == maxSigns - 1 {
            text += sign
        }
        // display
        print(text)
    }

    /// Display a lign of dashes.
    static func displayDashLine() {
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
