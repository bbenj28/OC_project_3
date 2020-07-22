//
//  Player.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

// MARK: Player

class Player {
    
        // MARK: Properties
    let name: String // player's name choosen in the home view
    
    //static
    var characters: [Character] = [] // list of player's character
    var isFull: Bool { // Are all player's characters created ?
        if characters.count == 3 {
            return true
        } else {
            return false
        }
    }
    let color: String // color of the player in views: blue or red
    
        // MARK: Init
    init(name: String, index: Int) {
        self.name = name
        if index == 0 {
            color = "blue"
        } else {
            color = "red"
        }
    }
    
        // MARK: Method
    func addCharacter(_ character: Character) {
        // add a new character in the list
        characters.append(character)
    }
}
