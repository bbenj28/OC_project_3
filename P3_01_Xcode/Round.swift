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
    var choosenTargetCharacter: Character? // the character choosed by the player to be the target
    var choosenSkill: SkillsType? // the choosen character's skill choosed by the player
    var activeStep: RoundSteps = .beginning // active step (RoundSteps) of the round
    var hasToChooseTarget: Bool {
        return choosenSkill == .multiAttack || choosenSkill == .multiHeal ? false : true
    }
        // MARK: Init
    init(playingPlayer: Player, watchingPlayer: Player) {
        self.playingPlayer = playingPlayer
        self.watchingPlayer = watchingPlayer
    }
    
        // MARK: Methods
    
    func start() -> Chest? {
        print("\(playingPlayer.name), your turn ! ************")
        print("******* SITUATION'S VIEW *******")
        displayCharacters(nil)
        print("\n\n\n******* Choose one of yours ******")
        while choosenCharacter == nil {
            choosenCharacter = chooseCharacter(of: playingPlayer)
        }
        guard let playingCharacter = choosenCharacter else {
            print("Fatal Error : Playing character returns nil.")
            exit(0)
        }
        activeStep = .firstCharacterIsSelected
        print("\n\n\n******* Choose a skill *******")
        
        while choosenSkill == nil {
            choosenSkill = chooseSkill(of: playingCharacter)
        }
        guard let playingSkill = choosenSkill else {
            print("Fatal Error : Playing skill returns nil.")
            exit(0)
        }
        activeStep = .skillIsSelected
        if hasToChooseTarget {
            print("\n\n\n******* Choose a target *******")
            while choosenTargetCharacter == nil {
                switch playingSkill {
                case .attack, .diversion:
                    choosenTargetCharacter = chooseCharacter(of: watchingPlayer)
                case .heal:
                    choosenTargetCharacter = chooseCharacter(of: playingPlayer)
                default:
                    print("Fatal Error : a target should not be asked for using a multiskill.")
                    exit(0)
                }
            }
        }
        activeStep = .targetCharacterIsSelected
        if let chest = endRoundAndReturnChest(character: playingCharacter, skill: playingSkill) {
            print("**********")
            print("CONGRATS! \(playingCharacter.name) found a chest !")
            print("Chest's content : \(chest.gift.name) [Str. \(chest.gift.strength)]")
            print("\(playingCharacter.name)'s weapon : \(playingCharacter.weapon.name) [Str. \(playingCharacter.weapon.strength)].")
            while chest.isAccepted == nil {
                chest.askForReplaceWeapon()
            }
            return chest
        }
        return nil
    }

    func chooseCharacter(of player: Player) -> Character? {
        let firstCharacterIndex = player.index * 3
        displayCharacters(player.index)
        print("Please, choose a character by enter a number between \(firstCharacterIndex + 1) and \(firstCharacterIndex + 3)")
        let choosenIndex = readLine()
        guard let verifiedIndex = choosenIndex else {
            return nil
        }
        guard let numberIndex = Int(verifiedIndex) else {
            return nil
        }
        if numberIndex >= firstCharacterIndex + 1 && numberIndex <= firstCharacterIndex + 3 {
            if Player.characters[numberIndex - 1].isDead {
                return nil
            }
            return Player.characters[numberIndex - 1]
        } else {
            return nil
        }
    }
    func displayCharacters(_ playerIndex: Int?) {
        let minIndex: Int
        let maxIndex: Int
        let displayAllCharacters: Bool
        if let index = playerIndex {
            minIndex = index * 3
            maxIndex = minIndex + 2
            displayAllCharacters = false
        } else {
            minIndex = 0
            maxIndex = 5
            displayAllCharacters = true
        }
        for index in minIndex...maxIndex {
            if displayAllCharacters && index == 0 {
                if playingPlayer.index == 0 {
                    print("\n\(playingPlayer.name)'s team")
                } else {
                    print("\n\(watchingPlayer.name)'s team")
                }
            }
            if displayAllCharacters && index == 3 {
                if playingPlayer.index == 1 {
                    print("\n\(playingPlayer.name)'s team")
                } else {
                    print("\n\(watchingPlayer.name)'s team")
                }
            }
            let character = Player.characters[index]
            if character.isDead && displayAllCharacters == false {
                break
            } else {
                displayCharacterInfo(index: index + 1, character: character)
            }
        }
    }
    func displayCharacterInfo(index: Int, character: Character) {
        var textToDisplay: String = "\(index). \(character.initials) \(character.name) "
        if character.isDiverted {
            textToDisplay += "🤪 "
        }
        if character.isDead {
            textToDisplay += "💀 "
        }
        textToDisplay += ": [Str. \(character.strength)] [HP \(character.healthPoints)/\(character.maxHealthPoints)]"
        print(textToDisplay)
    }
    func displaySkills(of character: Character) {
        print("1. \(character.skills[0].rawValue)")
        print("2. \(character.skills[1].rawValue)")
        if character.specialSkillIsAvailable == .available {
           print("3. \(character.skills[2].rawValue)")
        } else {
            print("3. \(character.skills[2].rawValue) [unavailable : used last round]")
        }
    }
    func chooseSkill(of character: Character) -> SkillsType? {
        displaySkills(of: character)
        print("Choose a skill by enter a number between 1 and 3.")
        let skill = readLine()
        guard let verifiedSkill = skill else {
            return nil
        }
        guard let indexSkill = Int(verifiedSkill) else {
            return nil
        }
        if indexSkill > 0 && indexSkill < 4{
            if indexSkill == 3 {
                if character.specialSkillIsAvailable != .available {
                    print("A character can't use its special skill if it has been used last round.")
                    return nil
                }
            }
            return character.skills[indexSkill - 1]
        }
        return nil
    }


    func endRoundAndReturnChest(character: Character, skill: SkillsType) -> Chest? {
        //launch the player choose skill, check diversion and skills availability of the player characters, and ask for a chest to return
        print("***************")
        useSkill(character: character, skill: skill)
        checkDiversion()
        checkSpecialSkillsAvailability()
        return randomChest(for: character)
    }
    private func useSkill(character: Character, skill: SkillsType) {
        //check the choosen skill to launch the associated method of the choosen character
        if let target = choosenTargetCharacter {
            print("\(character.name) utilise \(skill.rawValue) sur \(target.name).")
            switch skill {
            case .attack:
                character.attack(target)
            case .diversion:
                character.diversion(target)
            case .heal:
                character.heal(target)
            default:
                print("Fatal Error : A target is selected for a multiskill.")
                exit(0)
            }
        } else {
            print("\(character.name) utilise \(skill.rawValue).")
            switch skill {
            case .multiHeal:
                character.multiHeal(playingPlayer)
            case .multiAttack:
                character.multiAttack(watchingPlayer)
            default:
                print("Fatal Error : The selected skill needs a target.")
                exit(0)
            }
        }
        
    }

    private func checkDiversion() {
        //check if some characters of the playing player are diverted and reduce the diversion rounds
        let characters = [Player.characters[playingPlayer.index * 3], Player.characters[playingPlayer.index * 3 + 1], Player.characters[playingPlayer.index * 3 + 2]]
        for character in characters {
            if character.isDiverted {
                guard var rounds = character.diversionRounds else {
                    print("Fatal Error : \(character.name) isDiverted returns true, but diversionRounds returns nil.")
                    exit(0)
                }
                rounds -= 1
                if rounds == 0 {
                    character.diversionRounds = nil
                } else {
                    character.diversionRounds = rounds
                }
            }
        }
    }
    private func checkSpecialSkillsAvailability() {
        // check the availability of special skills of the playing player characters to make the just used special skill unavailable for the next round, and to make the used special skill in the last round available for the next.
        let characters = [Player.characters[playingPlayer.index * 3], Player.characters[playingPlayer.index * 3 + 1], Player.characters[playingPlayer.index * 3 + 2]]
        for character in characters {
            switch character.specialSkillIsAvailable {
            case .used:
                character.specialSkillIsAvailable = .unavailable
            default:
                character.specialSkillIsAvailable = .available
            }
        }
    }
    private func randomChest(for character: Character) -> Chest? {
        //choose a number between 1 and chances in bacproperties. If 1 : ask a chest generation
        let random: Int = Int.random(in: 1...bacproperties.chestChances)
        switch random {
        case 1:
            return chestGenerator(for: character)
        default:
            return nil
        }
    }
    private func chestGenerator(for character: Character) -> Chest {
        //ask a weapon generation and return a chest with this weapon
        let weapon = weaponGenerator(for: character)
        return Chest(gift: weapon, for: choosenCharacter!, player: playingPlayer)
    }
    private func weaponGenerator(for character: Character) -> Weapon {
        //generates a weapon
        switch character.type {
        case .druid:
            return HealthStick(firstWeapon: false, lifeStep: character.activeStep)
        case .joker:
            return Knife(firstWeapon: false, lifeStep: character.activeStep)
        case .warrior:
            return Sword(firstWeapon: false, lifeStep: character.activeStep)
        case .wizard:
            return PowerStick(firstWeapon: false, lifeStep: character.activeStep)
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
 
