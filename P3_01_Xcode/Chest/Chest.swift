//
//  Chest.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

// MARK: Chest

class Chest {
    
        // MARK: Properties
    let gift: Weapon // the weapon which is offered to the character
    var isAccepted: Bool? // the answer made by the player
    let character: Character // the character which will eventually get the weapon
    let player: Player // the player who decides
    
        // MARK: Init
    init(for character: Character, player: Player) {
        self.gift = character.type.createWeapon(firstWeapon: false, lifeStep: character.activeStep)
        self.character = character
        self.player = player
    }
    
        // MARK: Methods
    func accepted() {
        // if accepted, the gift becomes the new character's weapon
        character.weapon = gift
        isAccepted = true
        print("\nChest is accepted.")
    }
    func refused() {
        // if refused, the character's weapon doesn't change
        isAccepted = false
        print("\nChest is refused.")
    }
    func askForReplaceWeapon() {
        print("CONGRATS! \(character.name) found a chest !")
        print("Chest's content : \(gift.name) [Str. \(gift.strength)]")
        print("\(character.name)'s weapon : \(character.weapon.name) [Str. \(character.weapon.strength)].")
        let accepted = Ask.confirmation("Do you want to replace it with the chest's content ?")
        if accepted {
            self.accepted()
        } else {
            refused()
        }
    }
    
}
 
