//
//  Chest.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

class Chest {

    // MARK: - Properties

    /// The weapon which is in the chest.
    private let gift: Weapon

    /// The answer made by the player.
    var isAccepted: Bool?

    /// The character which will eventually get the weapon.
    private let character: Character

    /// The player who decides.
    let player: Player

    // MARK: - Init
    init(for character: Character, player: Player) {
        self.gift = character.type.createWeapon(for: character)
        self.character = character
        self.player = player
    }

    // MARK: - Methods

    /// Present chest's gift to the user and ask an answer.
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

    /// This method is called if the gift is accepted by the user.
    private func accepted() {
        // if accepted, the gift becomes the new character's weapon
        character.weapon = gift
        isAccepted = true
        print("\nChest is accepted.")
    }

    /// This method is called if the gift is refused by the user.
    private func refused() {
        // if refused, the character's weapon doesn't change
        isAccepted = false
        print("\nChest is refused.")
    }
}

