//
//  Ask.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 26/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation
class Ask {
    
        // MARK: Press enter
    static func pressEnter() {
        print("PRESS ENTER")
        let _ = readLine()
    }
    
        // MARK: Ask Confirmation
    /// Ask user to confirm choices by enter Y or N.
    /// ```
    /// let confirmation = Game.askForConfirmation("Are you sure ?")
    /// ```
    /// - parameter message : Message to display before asking user an answer.
    /// - returns: True if Y was entered, False if N was entered.
    static func confirmation(_ message: String) -> Bool {
        print("\(message) (Y/N)")
        var answer: Bool? = nil
        while answer == nil {
            answer = iterateConfirmation()
        }
        guard let confirmation = answer else {
            print("Fatal Error : confirmation returns nil.")
            exit(0)
        }
        return confirmation
    }
    /// Ask user to confirm choices by enter Y or N.
    /// - returns: True if Y was entered, False if N was entered, nil otherwise.
    static private func iterateConfirmation() -> Bool? {
        let answer = readLine()
        if let verifiedAnswer = answer {
            let newAnswer = spaceDeletion(verifiedAnswer)
            if newAnswer.lowercased() == "y" {
                return true
            }
            if newAnswer.lowercased() == "n" {
                return false
            }
        }
        print("Enter Y for Yes, N for No.")
        return nil
    }
    
        // MARK: Ask Number
    /// Ask user to choose a number.
    /// ```
    /// let skill = Game.askNumber(range: 1...3, message: "Choose a skill
    /// by enter a number between 1 and 3.", cancelProposition:
    /// "Enter 0 to cancel and choose another character.")
    /// ```
    /// - parameter range: Range in which user has to choose a number.
    /// - parameter message : Message to display before asking user a number.
    /// - parameter cancelProposition : Message to display to tell user cancel possibilty and its effect. Choose nil if the user can't cancel.
    /// - returns: The choosen number.
    static func number(range: ClosedRange<Int>, message: String, cancelProposition: String?) -> Int {
        // range verifications and get min and max values
        guard let min = range.min() else {
            print("Fatal Error : minimum value in range returns nil.")
            exit(0)
        }
        if min <= 0 {
            print("Fatal Error : range minimum has to be superior than zero.")
            exit(0)
        }
        guard let max = range.max() else {
            print("Fatal Error : maximum value in range returns nil.")
            exit(0)
        }
        if min >= max {
            print("Fatal Error : minimum value in range has to be inferior than its superior value.")
            exit(0)
        }
        // display messages and check cancel possibility
        print(message)
        let canCancel: Bool
        if let cancelMessage = cancelProposition {
            print(cancelMessage)
            canCancel = true
        } else {
            canCancel = false
        }
        // prepare error text
        let errorText: String
        if canCancel {
            errorText = "Enter a number between \(min) and \(max), or 0 to cancel."
        } else {
            errorText = "Enter a number between \(min) and \(max)."
        }
        // ask answer
        var answer: Int? = nil
        while answer == nil {
            answer = iterateNumber(range: range, canCancel: canCancel, errorText: errorText)
        }
        guard let number = answer else {
            print("Fatal Error : number returns nil.")
            exit(0)
        }
        // return number
        return number
    }
    /// Ask user to choose a number.
    /// - parameter range: Range in which user has to choose a number.
    /// - parameter canCancel : True if the user can cancel, false otherwise.
    /// - parameter errorText : Message to display if the choice is incorrect.
    /// - returns: The choosen number. Returns nil if the choice is incorrect.
    static private func iterateNumber(range: ClosedRange<Int>, canCancel: Bool, errorText: String) -> Int? {
        let number = readLine()
        if let existingNumber = number {
            let numberToVerify = spaceDeletion(existingNumber)
            if let verifiedNumber = Int(numberToVerify) {
                if verifiedNumber == 0 && canCancel {
                    return 0
                }
                if range.contains(verifiedNumber) {
                    return verifiedNumber
                }
            }
        }
        print(errorText)
        return nil
    }
    
        // MARK: Ask free answer
    /// Ask user to choose to enter a text.
    /// ```
    /// let name = askFreeAnswer("What's your name ?")
    /// ```
    /// - parameter message : Message to display before asking user an answer.
    /// - returns: The text entered by the user.
    static func freeAnswer(_ message: String) -> String {
        print(message)
        var answer: String? = nil
        while answer == nil {
            answer = iterateFreeAnswer()
        }
        guard let verifiedAnswer = answer else {
            print("Fatal Error : free answer returns nil.")
            exit(0)
        }
        return verifiedAnswer
    }
    static private func iterateFreeAnswer() -> String? {
        let answer = readLine()
        if let existingAnswer = answer {
            let verifiedAnswer = spaceDeletion(existingAnswer)
            if verifiedAnswer != "" {
                return verifiedAnswer
            }
        }
        print("Your answer is empty. Please enter a text.")
        return nil
    }
    
        // - MARK: Space deletion
    /// Delete spaces in the beginning and in the ending of a string.
    /// - parameter text : String to analyze.
    /// - returns: String without spaces.
    static private func spaceDeletion(_ text: String) -> String {
        var newText = text
        while newText.first == " " {
            newText.remove(at: newText.startIndex)
        }
        while newText.last == " " {
            newText.remove(at: newText.index(before: newText.endIndex))
        }
        return newText
    }
}
