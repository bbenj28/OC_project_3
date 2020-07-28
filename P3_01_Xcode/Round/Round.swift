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
    var choosenSkill: Skill? // the choosen character's skill choosed by the player
    var activeStep: RoundStep = .beginning // active step (RoundSteps) of the round
    var hasToChooseTarget: Bool {
        return choosenSkill == .multiAttack || choosenSkill == .multiHeal ? false : true
    }
    
    
        // MARK: Init
    
    
    
    init() {
        let playIndex: Int
        if Statistics.rounds.count > 0 {
            if Statistics.rounds[Statistics.rounds.count - 1].playingPlayer.name == Game.players[0].name {
                playIndex = 1
            } else {
                playIndex = 0
            }
        } else {
            playIndex = Int.random(in: 0...1)
        }
        playingPlayer = Game.players[playIndex]
        watchingPlayer = Game.players[(playIndex - 1) * (playIndex - 1)]
    }
    
    
    
        // MARK: Start
    
    
    
    /// Manage round from character's choice to chest appearance.
    /// - returns: The generated chest if a chest has been generated. Otherwise, returns *nil*.
    func startAndReturnChest() -> Chest? {
        // round's announcements
        StyleSheet.displayMiniTitle("\(playingPlayer.name), your turn !")
        StyleSheet.displayMiniTitle("SITUATION")
        let _ = displayCharacters(nil)
        StyleSheet.displayDashLine()
        // call step manager for player to choice characters and skill to use
        while activeStep != .confirmedChoices {
            activeStepManager()
        }
        // resolve round and manage chest appearance
        if let chest = endRoundAndReturnChest() {
            StyleSheet.displayMiniTitle("CHEST")
            chest.askForReplaceWeapon()
            StyleSheet.displayDashLine()
            return chest
        }
        // return nil if no chest has been appeared
        return nil
    }
    
    
    
        // MARK: ActiveStep manager
    
    
    
    /// Submit questions to player regarding the active round's step.
    private func activeStepManager() {
        activeStep.displayTitle()
        switch activeStep {
        case .beginning: // fighting character choice
            choosenCharacter = characterManager()
            if choosenCharacter != nil {
                activeStep = activeStep.moveForward(hasToChooseTarget)
            }
        case .firstCharacterIsSelected: // skill choice
            choosenSkill = skillManager()
            if choosenSkill != nil {
                activeStep = activeStep.moveForward(hasToChooseTarget)
            } else {
                choosenCharacter = nil
                activeStep = activeStep.cancelLastChoice(hasToChooseTarget)
            }
        case .skillIsSelected: // choose target
            choosenTargetCharacter = characterManager()
            if choosenTargetCharacter != nil {
                activeStep = activeStep.moveForward(hasToChooseTarget)
            } else {
                choosenSkill = nil
                activeStep = activeStep.cancelLastChoice(hasToChooseTarget)
            }
        case .targetCharacterIsSelected: // confirm choices
            if confirmChoices() {
                activeStep = activeStep.moveForward(hasToChooseTarget)
            } else {
                choosenTargetCharacter = nil
                activeStep = activeStep.cancelLastChoice(hasToChooseTarget)
            }
        case .confirmedChoices: // choices have been confirmed
            break
        }
        if activeStep != .confirmedChoices { // display choices
            displayChoices()
        }
    }
    
    /// Display choices made by user.
    private func displayChoices() {
        if let character = choosenCharacter {
            if let skill = choosenSkill {
                if let target = choosenTargetCharacter {
                    print("\n Your choices : \(askCharacterInformation(character)) → \(skill.name()) → \(askCharacterInformation(target))")
                } else {
                    print("\n Your choices : \(askCharacterInformation(character)) → \(skill.name())")
                }
            } else {
                print("\n Your choice : \(askCharacterInformation(character))")
            }
        } else {
            print("\nNo choice have been made for now.")
        }
    }
    
    /// Ask character information.
    /// - parameter character : Character of which informations have to be displayed.
    /// - returns: Informations to display.
    func askCharacterInformation(_ character: Character) -> String {
        let info = character.displayInformations(full: false, evenDead: false)
        guard let infoToReturn = info else {
            print("Fatal Error : character's informations returns nil.")
            exit(0)
        }
        return infoToReturn
    }
    
    
    
        // MARK: Characters choices
    
    
    
    /// Ask player to choose a character, or to cancel last choice.
    /// - returns: If the player has made a choice, returns the character ; otherwise returns nil to cancel last choice.
    private func characterManager() -> Character? {
        // get parameters
        let characters = charactersList()
        let cancel = cancelProposition()
        // ask user to choose a character
        var character: Character? = nil
        while character == nil {
            // display characters and check remaining characters number
            let remainingCharactersCount = displayCharacters(characters)
            if remainingCharactersCount == 1 {
                // if it remains a single character, then this one is choosen
                for remainCharacter in characters {
                    if remainCharacter.isDead == false {
                        character = remainCharacter
                    }
                }
            } else {
                // otherwise, let user choose a character
                let index: Int
                if characters[0].name == playingPlayer.characters[0].name {
                    index = playingPlayer.index
                } else {
                    index  = watchingPlayer.index
                }
                let number = Ask.number(
                    range: index * 3 + 1...index * 3 + 3,
                    message: "Please, choose a character by enter a number between \(index * 3 + 1) and \(index * 3 + 3)",
                    cancelProposition: cancel)
                if number == 0 {
                    return nil
                } else {
                    character = choosedCharacter(number: number)
                }
            }
        }
        return character
    }
    
    /// Ask characters list of the player of whom the character has to be choosen.
    /// - returns: Characters list.
    private func charactersList() -> [Character] {
        guard let skill = choosenSkill else {
            return playingPlayer.characters
        }
        return skill.targetCharacters()
    }
    
    /// Ask the cancel proposition if the user can cancel.
    /// - returns: The cancel message.
    private func cancelProposition() -> String? {
        // prepare parameters before asking
        let cancelProposition: String? // can user enter 0 to cancel ?
        if activeStep == .skillIsSelected {
            cancelProposition = "Enter 0 to cancel and choose another skill."
        } else {
            cancelProposition = nil
        }
        return cancelProposition
    }
    
    /// Verify if the choosen character can be used by the user.
    /// - parameter number: Choosen number by the user.
    /// - returns: If the choosen character can be used, returns the character. Otherwise, returns *nil*.
    private func choosedCharacter(number: Int) -> Character? {
        if Player.characters[number - 1].isDead {
            return nil
        }
        return Player.characters[number - 1]
    }
    
    /// Display a characters list.
    /// - parameter charactersList: To display the characters list, enter it. To display all characters, enter *nil*.
    /// - returns: Displayed characters count.
    private func displayCharacters(_ charactersList: [Character]?) -> Int {
        // prepare parameters
        var totalDisplayed: Int = 0
        let minIndex: Int
        let maxIndex: Int
        let displayAllCharacters: Bool
        if let characters = charactersList {
            if characters[0].name == Player.characters[0].name {
                minIndex = 0
                maxIndex = 2
            } else {
                minIndex = 3
                maxIndex = 5
            }
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
                playingPlayer.displayTeamSituation(0)
                watchingPlayer.displayTeamSituation(0)
            }
            if displayAllCharacters && index == 3 {
                playingPlayer.displayTeamSituation(1)
                watchingPlayer.displayTeamSituation(1)
            }
            // display character
            if let info = Player.characters[index].displayInformations(full: true, evenDead: displayAllCharacters) {
                print(info)
                totalDisplayed += 1
            }
        }
        return totalDisplayed
    }
    
    
    
        // MARK: Choices verification
    
    
    
    /// Verify if the choosen character exists.
    /// - warning: This method needs to be sure choosen character has been choosen. If choosenCharacterl returns nil, the application will returns a Fatal Error.
    /// - returns: The choosen character.
    func isChoosenCharacterExisting() -> Character {
        guard let character = choosenCharacter else {
            print("Fatal Error : choosen character returns nil.")
            exit (0)
        }
        return character
    }
    
    /// Verify if the choosen skill exists.
    /// - warning: This method needs to be sure choosen skill has been choosen. If choosenSkill returns nil, the application will returns a Fatal Error.
    /// - returns: The choosen skill.
    func isChooseSkillExisting() -> Skill {
        guard let skill = choosenSkill else {
            print("Fatal Error : choosen skill returns nil.")
            exit (0)
        }
        return skill
    }
    
    /// Ask user to confirm choices by enter Y or N.
    /// - returns: *true* if Y was entered, *false* if N was entered.
    private func confirmChoices() -> Bool {
        return Ask.confirmation("Do you confirm your choices ?")
    }
    
    
    
        // MARK: Skill choice
    
    
    
    /// Ask player to choose a character, or cancel last choice.
    /// - returns: If the player has made a choice, returns the character ; otherwise returns nil to cancel last choice.
    private func skillManager() -> Skill? {
        // get choosen character to display its skill
        let character = isChoosenCharacterExisting()
        // ask user to choose a skill
        displaySkills(of: character)
        var skill: Skill? = nil
        while skill == nil {
            let number = Ask.number(
                range: 1...character.skills.count,
                message: "Choose a skill by enter a number between 1 and \(character.skills.count).",
                cancelProposition: "Enter 0 to cancel and choose another character.")
            if number == 0 {
                return nil
            } else {
                skill = verifySkillAvailability(of: character, number: number)
            }
        }
        return skill
    }
    
    /// Display skills of a character.
    /// - parameter character: Character of which the skills have to be displayed.
    private func displaySkills(of character: Character) {
        let character = isChoosenCharacterExisting()
        character.displaySkills()
    }
    
    /// Check if the choosen skill is available and returns it.
    /// - parameter character: Character of which the skill belongs.
    /// - parameter number: Index of the skill in character's skills.
    /// - returns: The skill if available. Otherwise, returns nil.
    private func verifySkillAvailability(of character: Character, number: Int) -> Skill? {
        if number == 3 {
            if character.specialSkillIsAvailable != .available {
                print("A character can't use its special skill if it has been used last round.")
                return nil
            }
        }
        return character.skills[number - 1]
    }
    
    

    
    
        // MARK: End round

    
    /// End the round and check if a chest is generated.
    /// - returns: Chest if it has been generated. Otherwise, returns nil.
    func endRoundAndReturnChest() -> Chest? {
        //launch the player choose skill and display result
        StyleSheet.displayDashLine()
        StyleSheet.displayMiniTitle("RESULT")
        useSkill()
        Ask.pressEnter()
        StyleSheet.displayDashLine()
        // check diversion
        checkDiversion()
        // check special skills availability of the player characters
        checkSpecialSkillsAvailability()
        // return a chest if it has been generated
        return randomChest()
    }
    
    /// Use the choosen skill.
    private func useSkill() {
        // order character to use its skill.
        let character = isChoosenCharacterExisting()
        character.executeOrder66()
    }
    
    /// Check if player's characters are diverted, and reduce their diversion's rounds count.
    private func checkDiversion() {
        // for each character, check if they are diverted and reduce their diversion's rounds count
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
        let random: Int = Int.random(in: 1...BACProperties.chestChances)
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
        let character = isChoosenCharacterExisting()
        return Chest(for: character, player: playingPlayer)
    }
}
