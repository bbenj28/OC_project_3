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
        Game.displayMiniTitle("\(playingPlayer.name), your turn !")
        Game.displayMiniTitle("SITUATION'S VIEW")
        let _ = displayCharacters(nil)
        Game.displayStarLine()
        // call step manager for player to choice characters and skill to use
        while activeStep != .confirmedChoices {
            activeStepManager()
        }
        // resolve round and manage chest appearance
        if let chest = endRoundAndReturnChest() {
            Game.displayMiniTitle("CHEST")
            let character = verifyChoosenCharacter()
            print("CONGRATS! \(character.name) found a chest !")
            print("Chest's content : \(chest.gift.name) [Str. \(chest.gift.strength)]")
            print("\(character.name)'s weapon : \(character.weapon.name) [Str. \(character.weapon.strength)].")
            chest.askForReplaceWeapon()
            Game.displayStarLine()
            return chest
        }
        
        // return nil if no chest has been appeared
        return nil
    }
    
    
    
        // MARK: ActiveStep manager
    
    
    
    /// Submit questions to player regarding the active round's step.
    private func activeStepManager() {
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
    private func cancelLastChoice() {
        switch activeStep {
        case .beginning, .firstCharacterIsSelected:
            choosenCharacter = nil
            activeStep = .beginning
        case .skillIsSelected:
            choosenSkill = nil
            activeStep = .firstCharacterIsSelected
        case .targetCharacterIsSelected:
            let skill = verifyChoosenSkill()
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
    private func confirmChoices() -> Bool {
        Game.displayMiniTitle("CONFIRMATION")
        return Game.askForConfirmation("Do you confirm your choices ?")
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
    private func characterManager() -> Character? {
        // prepare parameters before asking
        let charactersPlayer: Player // among the characters of which player the choice have to be done ?
        let cancelProposition: String? // can user enter 0 to cancel ?
        if activeStep == .skillIsSelected {
            Game.displayMiniTitle("Choose a target")
            let usedSkill = verifyChoosenSkill()
            switch usedSkill {
            case .attack, .diversion:
                charactersPlayer = watchingPlayer
            case .heal:
                charactersPlayer = playingPlayer
            default:
                print("Fatal Error : a target should not be asked for using a multiskill.")
                exit(0)
            }
            cancelProposition = "Enter 0 to cancel and choose another skill."
        } else {
            Game.displayMiniTitle("Choose a character of yours")
            charactersPlayer = playingPlayer
            cancelProposition = nil
        }
        // Ask user to choose a character
        var character: Character? = nil
        while character == nil {
            let remainingCharactersCount = displayCharacters(charactersPlayer.index)
            if remainingCharactersCount == 1 {
                for remainCharacter in charactersPlayer.characters {
                    if remainCharacter.isDead == false {
                        character = remainCharacter
                    }
                }
            } else {
                let number = Game.askNumber(
                    range: charactersPlayer.index * 3 + 1...charactersPlayer.index * 3 + 3,
                    message: "Please, choose a character by enter a number between \(charactersPlayer.index * 3 + 1) and \(charactersPlayer.index * 3 + 3)",
                    cancelProposition: cancelProposition)
                if number == 0 {
                    return nil
                } else {
                    character = choosedCharacter(number: number)
                }
            }
        }
        return character
    }
    
    /// Verify if the choosen character can be use by the user.
    /// - parameter number: Choosen number by the user.
    /// - returns: If the choosen character can be used, returns the character. Otherwise, returns nil.
    private func choosedCharacter(number: Int) -> Character? {
        if Player.characters[number - 1].isDead {
            return nil
        }
        return Player.characters[number - 1]
    }
    
    /// Display a characters list.
    /// - parameter playerIndex: To display the characters list of a specific player, enter his number. Otherwise, to display the entire list, enter nil.
    private func displayCharacters(_ playerIndex: Int?) -> Int {
        // prepare parameters
        var totalDisplayed: Int = 0
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
                totalDisplayed += 1
            } else if character.isDead == false {
                displayCharacterInfo(index: index)
                totalDisplayed += 1
            }
        }
        return totalDisplayed
    }
    
    /// Display informations about a character.
    /// - parameter index: Index of the character in Player.characters.
    private func displayCharacterInfo(index: Int) {
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
    
    /// Verify if the choosen character exists.
    /// - warning: This method needs to be sure choosen character has been choosen. If choosenCharacterl returns nil, the application will returns a Fatal Error.
    /// - returns: The choosen character.
    func verifyChoosenCharacter() -> Character {
        guard let character = choosenCharacter else {
            print("Fatal Error : choosen character returns nil.")
            exit (0)
        }
        return character
    }
    
    
    
        // MARK: Skill choice
    
    
    
    /// Ask player to choose a character, or cancel last choice.
    /// - returns: If the player has made a choice, returns the character ; otherwise returns nil to cancel last choice.
    private func skillManager() -> SkillsType? {
        // get choosen character to display its skill
        Game.displayMiniTitle("Choose a skill")
        let character = verifyChoosenCharacter()
        
        // ask user to choose a skill
        displaySkills(of: character)
        let number = Game.askNumber(
            range: 1...3,
            message: "Choose a skill by enter a number between 1 and 3.",
            cancelProposition: "Enter 0 to cancel and choose another character.")
        if number == 0 {
            return nil
        } else {
            return chooseSkill(of: character, number: number)
        }
    }
    
    /// Display skills of a character.
    /// - parameter character: Character of which the skills have to be displayed.
    private func displaySkills(of character: Character) {
        print("1. \(character.skills[0].rawValue)")
        print("2. \(character.skills[1].rawValue)")
        if character.specialSkillIsAvailable == .available {
           print("3. \(character.skills[2].rawValue)")
        } else {
            print("3. \(character.skills[2].rawValue) [unavailable : used last round]")
        }
    }
    
    /// Check if the choosen skill is available and returns it.
    /// - parameter character: Character of which the skill belongs.
    /// - parameter number: Index of the skill in character's skills.
    /// - returns: The skill if available. Otherwise, returns nil.
    private func chooseSkill(of character: Character, number: Int) -> SkillsType? {
        if number == 3 {
            if character.specialSkillIsAvailable != .available {
                print("A character can't use its special skill if it has been used last round.")
                return nil
            }
        }
        return character.skills[number - 1]
    }
    
    /// Verify if the choosen skill exists.
    /// - warning: This method needs to be sure choosen skill has been choosen. If choosenSkill returns nil, the application will returns a Fatal Error.
    /// - returns: The choosen skill.
    func verifyChoosenSkill() -> SkillsType {
        guard let skill = choosenSkill else {
            print("Fatal Error : choosen skill returns nil.")
            exit (0)
        }
        return skill
    }

    
    
        // MARK: End round

    
    /// End the round and check if a chest is generated.
    /// - returns: Chest if it has been generated. Otherwise, returns nil.
    func endRoundAndReturnChest() -> Chest? {
        //launch the player choose skill and display result
        Game.displayStarLine()
        Game.displayMiniTitle("RESULT")
        useSkill()
        Game.pressEnter()
        Game.displayStarLine()
        // check diversion
        checkDiversion()
        // check special skills availability of the player characters
        checkSpecialSkillsAvailability()
        // return a chest if it has been generated
        return randomChest()
    }
    
    /// Use the choosen skill.
    private func useSkill() {
        // get parameters
        let character = verifyChoosenCharacter()
        let skill = verifyChoosenSkill()
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
    
    /// Check if player's characters are diverted, and reduce their diversion's rounds count.
    private func checkDiversion() {
        // for each character, check if they are diverted and reduce their diversion's rouns count
        for character in playingPlayer.characters {
            if character.isDiverted {
                guard var rounds = character.diversionRounds else {
                    print("Fatal Error : \(character.name)'s isDiverted returns true, but diversionRounds returns nil.")
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
    
    /// Check the availability of player's characters special skill to make the just used special skill unavailable for the next round, and to make the used special skill in the last round available for the next.
    private func checkSpecialSkillsAvailability() {
        // check for each character
        for character in playingPlayer.characters {
            switch character.specialSkillIsAvailable {
            case .used:
                character.specialSkillIsAvailable = .unavailable
            default:
                character.specialSkillIsAvailable = .available
            }
        }
    }
    
    /// Choose a number between 1 and chances in bacproperties. If 1 : generate a chest and return it.
    /// - returns: Chest if it has been generated. Otherwise, returns nil.
    private func randomChest() -> Chest? {
        // random number
        let random: Int = Int.random(in: 1...bacproperties.chestChances)
        switch random {
        case 1:
            return chestGenerator()
        default:
            return nil
        }
    }
    
    /// Generate a chest.
    /// - returns: Generated chest.
    private func chestGenerator() -> Chest {
        // get character
        let character = verifyChoosenCharacter()
        //ask a weapon generation and return a chest with this weapon
        let weapon = weaponGenerator(for: character)
        return Chest(gift: weapon, for: character, player: playingPlayer)
    }
    
    /// Generate weapon.
    /// - returns: Generated weapon.
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

 
