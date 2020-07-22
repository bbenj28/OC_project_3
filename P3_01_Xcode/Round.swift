//
//  Round.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 03/07/2020.
//  Copyright © 2020 bretonbenjamin. All rights reserved.
//

import Foundation

// MARK: Round

class Round {
    
        // MARK: Properties
    let playingPlayer: Player // the player who will choose the action to do in the round
    let watchingPlayer: Player // the other player
    var choosenCharacter: Character? // the character choosed by the player to do an action
    var targetCharacter: Character? // the character choosed by the player to be the target
    var choosenSkill: SkillsType? // the choosen character's skill choosed by the player
    var victoriousPlayer: Bool { // is the playing player victorious after his action ?
        //check if the characters of the watching player are all dead, and return true if they are
        if watchingPlayer.characters[0].isDead && watchingPlayer.characters[1].isDead && watchingPlayer.characters[2].isDead {
            return true
        } else {
            return false
        }
    }
    var activeStep: RoundSteps = .beginning // active step (RoundSteps) of the round
    
        // MARK: Init
    init(playingPlayer: Player, watchingPlayer: Player) {
        self.playingPlayer = playingPlayer
        self.watchingPlayer = watchingPlayer
    }
    
        // MARK: Methods
    func chooseCharacter(_ index: Int) {
        //save the character choosen by the player in the view
        choosenCharacter = playingPlayer.characters[index]
        activeStep = .firstCharacterIsSelected
    }
    func chooseSkill(_ type: SkillsType) {
        //save the character skill choosen to be played by the player
        choosenSkill = type
        activeStep = .skillIsSelected
    }
    func chooseTarget(_ index: Int) {
        //save the target of the choosen skill and launch the end of the round
        activeStep = .targetCharacterIsSelected
        switch choosenSkill! {
        case .attack, .diversion, .multiAttack:
            targetCharacter = watchingPlayer.characters[index]
        case .heal, .multiHeal:
            targetCharacter = playingPlayer.characters[index]
        }
    }
    func endRoundAndReturnChest() -> Chest? {
        //launch the player choose skill, check diversion and skills availability of the player characters, and ask for a chest to return
        useSkill()
        if victoriousPlayer {
            return nil
        }
        checkDiversion()
        checkSpecialSkillsAvailability()
        return randomChest(choosenCharacter!.activeStep)
    }
    private func useSkill() {
        //check the choosen skill to launch the associated method of the choosen character
        switch choosenSkill! {
        case .attack:
            choosenCharacter!.attack(targetCharacter!)
        case .diversion:
            choosenCharacter!.diversion(targetCharacter!)
        case .heal:
            choosenCharacter!.heal(targetCharacter!)
        case .multiAttack:
            choosenCharacter!.multiAttack(watchingPlayer)
        case .multiHeal:
            choosenCharacter!.multiHeal(playingPlayer)
        }
    }
    private func checkDiversion() {
        //check if some characters of the playing player are diverted and reduce the diversion rounds
        for character in playingPlayer.characters {
            if character.isDiverted {
                character.diversionRounds! -= 1
                if character.diversionRounds! == 0 {
                    character.diversionRounds = nil
                }
            }
        }
    }
    private func checkSpecialSkillsAvailability() {
        // check the availability of special skills of the playing player characters to make the just used special skill unavailable for the next round, and to make the used special skill in the last round available for the next.
        for character in playingPlayer.characters {
            switch character.specialSkillIsAvailable {
            case .used:
                character.specialSkillIsAvailable = .unavailable
            default:
                character.specialSkillIsAvailable = .available
            }
        }
    }
    private func randomChest(_ lifeStep: LifeSteps) -> Chest? {
        //choose a number between 1 and chances in bacproperties. If 1 : ask a chest generation
        let random: Int = Int.random(in: 1...bacproperties.chestChances)
        switch random {
        case 1:
            return chestGenerator(lifeStep)
        default:
            return nil
        }
    }
    private func chestGenerator(_ lifeStep: LifeSteps) -> Chest {
        //ask a weapon generation and return a chest with this weapon
        let weapon = weaponGenerator(lifeStep)
        return Chest(gift: weapon, for: choosenCharacter!, player: playingPlayer)
    }
    private func weaponGenerator(_ lifeStep: LifeSteps) -> Weapon {
        //generates a weapon
        switch choosenCharacter!.type {
        case .druid:
            return HealthStick(firstWeapon: false, lifeStep: lifeStep)
        case .joker:
            return Knife(firstWeapon: false, lifeStep: lifeStep)
        case .warrior:
            return Sword(firstWeapon: false, lifeStep: lifeStep)
        case .wizard:
            return PowerStick(firstWeapon: false, lifeStep: lifeStep)
        }
    }
}


// MARK: Enumerations based on round's properties



        // MARK: RoundSteps

enum RoundSteps {
    // enumerates the differents steps in a round
    case beginning
    case firstCharacterIsSelected
    case skillIsSelected
    case targetCharacterIsSelected
}
