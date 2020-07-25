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
    
        // MARK: Start
    
    
    /// Manage round from character's choice to chest appearance.
    func start() -> Chest? {
        // round's announcements
        print("\(playingPlayer.name), your turn ! ************")
        print("******* SITUATION'S VIEW *******")
        displayCharacters(nil)
        
        // call step manager for player to choice characters and skill to use
        while activeStep != .confirmedChoices {
            activeStepManager()
        }
        
        // verify first choices
        guard let fightingCharacter = choosenCharacter else {
            print("Fatal error : choosen character returns nil.")
            exit (0)
        }
        guard let usedSkill = choosenSkill else {
            print("Fatal error: choosen skill returns nil.")
            exit(0)
        }
        
        // resolve round and manage chest appearance
        if let chest = endRoundAndReturnChest(character: fightingCharacter, skill: usedSkill) {
            print("\n\n\n***************")
            print("CONGRATS! \(fightingCharacter.name) found a chest !")
            print("Chest's content : \(chest.gift.name) [Str. \(chest.gift.strength)]")
            print("\(fightingCharacter.name)'s weapon : \(fightingCharacter.weapon.name) [Str. \(fightingCharacter.weapon.strength)].")
            while chest.isAccepted == nil {
                chest.askForReplaceWeapon()
            }
            print("***************")
            return chest
        }
        
        // return nil if no chest has been appeared
        return nil
    }
    
        // MARK: ActiveStep manager
    /// Submit questions to player regarding the active round's step.
    func activeStepManager() {
        switch activeStep {
        case .beginning: // fighting character choice
            choosenCharacter = characterManager()
            if choosenCharacter != nil {
                activeStep = .firstCharacterIsSelected
            }
        case .firstCharacterIsSelected: // skill choice
            choosenSkill = skillManager()
            if choosenSkill != nil {
                if hasToChooseTarget {
                    activeStep = .skillIsSelected
                } else {
                    activeStep = .targetCharacterIsSelected
                }
            } else {
                cancelLastChoice()
            }
        case .skillIsSelected: // choose target
            choosenTargetCharacter = characterManager()
            if choosenTargetCharacter == nil {
                cancelLastChoice()
            } else {
                activeStep = .targetCharacterIsSelected
            }
        case .targetCharacterIsSelected: // confirm choices
            if confirmChoices() {
                activeStep = .confirmedChoices
            } else {
                cancelLastChoice()
            }
        case .confirmedChoices: // choices have been confirmed
            break
        }
        if activeStep != .confirmedChoices { // display choices
            displayChoices()
        }
    }
    /// Cancel last choice made by player by changing active step.
    func cancelLastChoice() {
        switch activeStep {
        case .beginning, .firstCharacterIsSelected:
            choosenCharacter = nil
            activeStep = .beginning
        case .skillIsSelected:
            choosenSkill = nil
            activeStep = .firstCharacterIsSelected
        case .targetCharacterIsSelected:
            guard let skill = choosenSkill else {
                print("Fatal Error : choosen skill returns nil.")
                exit(0)
            }
            if skill == .multiHeal || skill == .multiAttack {
                choosenTargetCharacter = nil
                choosenSkill = nil
                activeStep = .firstCharacterIsSelected
            } else {
                choosenTargetCharacter = nil
                activeStep = .skillIsSelected
            }
        case .confirmedChoices:
            break
        }
    }
    /// Ask user to confirm choices by enter Y or N.
    /// - returns: True if Y was entered, False if N was entered.
    func confirmChoices() -> Bool {
        var confirmation: Bool? = nil
        while confirmation == nil {
            confirmation = askForConfirmation()
        }
        guard let verifiedConfirmation = confirmation else {
            print("Fatal Error : confirmation returns nil.")
            exit(0)
        }
        return verifiedConfirmation
    }
    /// Ask user to confirm choices by enter Y or N.
    /// - returns: True if Y was entered, False if N was entered, nil otherwise.
    func askForConfirmation() -> Bool? {
        print("\nDo you confirm ? (Y/N)")
        let answer = readLine()
        if let verifiedAnswer = answer {
            if verifiedAnswer.lowercased() == "y" {
                return true
            }
            if verifiedAnswer.lowercased() == "n" {
                return false
            }
        }
        return nil
    }
    /// Ask user to choose a number.
    /// - parameter min: The minimum number the user can enter (without 0 case).
    /// - parameter max: The maximum number the user can enter.
    /// - parameter canCancel : Can the user enter 0 to cancel last choice ? True if he cans, False otherwise.
    /// - returns: The choosen number. Returns nil if the choice is incorrect.
    func askNumber(min: Int, max: Int, canCancel: Bool) -> Int? {
        let number = readLine()
        guard let existingNumber = number else {
            print("A number have to be entered.")
            return nil
        }
        guard let verifiedNumber = Int(existingNumber) else {
            print("A number have to be entered.")
            return nil
        }
        if verifiedNumber == 0 && canCancel {
            return 0
        }
        if verifiedNumber < min || verifiedNumber > max {
            return nil
        } else {
            return verifiedNumber
        }
    }
    /// Display choices made by user.
    private func displayChoices() {
        if let character = choosenCharacter {
            if let skill = choosenSkill {
                if let target = choosenTargetCharacter {
                    print("\n Your choices : \(character.initials) \(character.emoticon) \(character.name) → \(skill.rawValue) → \(target.initials) \(target.emoticon) \(target.name)")
                } else {
                    print("\n Your choices : \(character.initials) \(character.emoticon) \(character.name) → \(skill.rawValue)")
                }
            } else {
                print("\n Your choice : \(character.initials) \(character.emoticon) \(character.name)")
            }
        } else {
            print("\nNo choice have been made for now.")
        }
    }
        // MARK: Characters choices
    /// Ask player to choose a character, or cancel last choice.
    /// - returns: If the player has made a choice, returns the character ; otherwise returns nil to cancel last choice.
    func characterManager() -> Character? {
        // prepare parameters before asking
        let charactersPlayer: Player // among the characters of which player the choice have to be done ?
        let canCancel: Bool // can user enter 0 to cancel ?
        if activeStep == .skillIsSelected {
            print("\n\n\n******* Choose a target *******")
            guard let usedSkill = choosenSkill else {
                print("Fatal Error : choosen skill returns nil.")
                exit(0)
            }
            switch usedSkill {
            case .attack, .diversion:
                charactersPlayer = watchingPlayer
            case .heal:
                charactersPlayer = playingPlayer
            default:
                print("Fatal Error : a target should not be asked for using a multiskill.")
                exit(0)
            }
            canCancel = true
        } else {
            print("\n\n\n******* Choose a character of yours ******")
            charactersPlayer = playingPlayer
            canCancel = false
        }
        
        // Ask user to choose a character
        var character: Character? = nil
        while character == nil {
            displayCharacters(charactersPlayer.index)
            print("Please, choose a character by enter a number between \(charactersPlayer.index * 3 + 1) and \(charactersPlayer.index * 3 + 3)")
            if activeStep == .skillIsSelected {
                print("Enter 0 to cancel and choose another skill.")
            }
            let number = askNumber(min: charactersPlayer.index * 3 + 1, max: charactersPlayer.index * 3 + 3, canCancel: canCancel)
            if let verifiedNumber = number {
                if number == 0 {
                    return nil
                } else {
                    character = choosedCharacter(number: verifiedNumber)
                }
            }
        }
        return character
    }
    /// Verify if the choosen character can be use by the user.
    /// - parameter number: Choosen number by the user.
    /// - returns: If the choosen character can be used, returns the character. Otherwise, returns nil.
    func choosedCharacter(number: Int) -> Character? {
        if Player.characters[number - 1].isDead {
            return nil
        }
        return Player.characters[number - 1]
    }
    /// Display a characters list.
    /// - parameter playerIndex: To display the characters list of a specific player, enter his number. Otherwise, to display the entire list, enter nil.
    func displayCharacters(_ playerIndex: Int?) {
        // prepare parameters
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
        
        // display characters list
        for index in minIndex...maxIndex {
            // if the entire list is to display, enter the name of players and their HP situation before their characters list.
            if displayAllCharacters && index == 0 {
                if playingPlayer.index == 0 {
                    print("\n\(playingPlayer.name)'s team [\(playingPlayer.HPSituation) %]")
                } else {
                    print("\n\(watchingPlayer.name)'s team [\(watchingPlayer.HPSituation) %]")
                }
            }
            if displayAllCharacters && index == 3 {
                if playingPlayer.index == 1 {
                    print("\n\(playingPlayer.name)'s team [\(playingPlayer.HPSituation) %]")
                } else {
                    print("\n\(watchingPlayer.name)'s team [\(watchingPlayer.HPSituation) %]")
                }
            }
            // display character
            let character = Player.characters[index]
            if displayAllCharacters {
                displayCharacterInfo(index: index)
            } else if character.isDead == false {
                displayCharacterInfo(index: index)
            }
        }
    }
    /// Display informations about a character.
    /// - parameter index: Index of the character in Player.characters.
    func displayCharacterInfo(index: Int) {
        let character = Player.characters[index]
        let emoticon: String
        if character.isDiverted {
            emoticon = "🤪 "
        } else if character.isDead {
            emoticon = "💀 "
        } else {
            emoticon = character.emoticon
        }
        print("\(index + 1). \(character.initials) \(emoticon) \(character.name) : [Str. \(character.strength)] [HP \(character.healthPoints)/\(character.maxHealthPoints)]")
    }
    
        // MARK: Skill choice
    /// Ask player to choose a character, or cancel last choice.
    /// - returns: If the player has made a choice, returns the character ; otherwise returns nil to cancel last choice.
    func skillManager() -> SkillsType? {
        // get choosen character to display its skill
        print("\n\n\n******* Choose a skill *******")
        guard let fightingCharacter = choosenCharacter else {
            print("Fatal Error : choosen character returns nil.")
            exit(0)
        }
        
        // ask user to choose a skill
        var skill: SkillsType? = nil
        while skill == nil {
            displaySkills(of: fightingCharacter)
            print("Choose a skill by enter a number between 1 and 3.")
            print("Enter 0 to cancel and choose another character.")
            let number = askNumber(min: 1, max: 3, canCancel: true)
            if let verifiedNumber = number {
                if verifiedNumber == 0 {
                    return nil
                } else {
                    skill = chooseSkill(of: fightingCharacter, number: verifiedNumber)
                }
            }
        }
        return skill
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
    func chooseSkill(of character: Character, number: Int) -> SkillsType? {
        if number == 3 {
            if character.specialSkillIsAvailable != .available {
                print("A character can't use its special skill if it has been used last round.")
                return nil
            }
        }
        return character.skills[number - 1]
    }


    func endRoundAndReturnChest(character: Character, skill: SkillsType) -> Chest? {
        //launch the player choose skill, check diversion and skills availability of the player characters, and ask for a chest to return
        print("\n\n\n***************")
        useSkill(character: character, skill: skill)
        print("***************")
        checkDiversion()
        checkSpecialSkillsAvailability()
        return randomChest(for: character)
    }
    private func useSkill(character: Character, skill: SkillsType) {
        //check the choosen skill to launch the associated method of the choosen character
        if let target = choosenTargetCharacter {
            print("\(character.name) used \(skill.rawValue) on \(target.name).")
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
            print("\(character.name) used \(skill.rawValue).")
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
    case confirmedChoices
}

 
