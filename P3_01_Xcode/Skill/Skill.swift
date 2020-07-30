//
//  SkillType.swift
//  P3_01_Xcode
//
//  Created by Benjamin Breton on 27/07/2020.
//  Copyright © 2020 bb. All rights reserved.
//

import Foundation

enum Skill {

    // the differents existing skills a character can use. All characters can use attack and heal, specialskill depends on its type.
    case attack
    case heal
    case multiAttack
    case multiHeal
    case diversion

    // MARK: - Informations to ask

    /// Ask for skill's name.
    /// - returns: Skill's name.
    func name() -> String {
        switch self {
        case .attack:
            return "🗡 Attack"
        case .heal:
            return "🧪 Heal"
        case .multiAttack:
            return "⚔️ MultiAttack"
        case .multiHeal:
            return "💊 MultiHeal"
        case .diversion:
            return "🤡 Diversion"
        }
    }

    /// Ask for skill's description.
    /// - returns: Skill's description.
    func description() -> String {
        switch self {
        case .multiAttack:
            return BACProperties.multiAttackDescription
        case .multiHeal:
            return BACProperties.multiHealDescription
        case .diversion:
            return BACProperties.diversionDescription
        default:
            return ""
        }
    }

    /// Ask for index of the player of whom one of the characters has to be choosen.
    /// - returns: Player's index.
    func targetCharacters() -> [Character] {
        let round = Game.returnActiveRound()
        switch self {
        case .attack, .multiAttack, .diversion:
            return round.watchingPlayer.characters
        case .heal, .multiHeal:
            return round.playingPlayer.characters
        }
    }

    // MARK: - Use

    /// Use skill.
    /// - parameter user: The character which use the skill.
    /// - parameter target: The characters which will be targets of the skill.
    func use(user: Character, target: [Character]) {
        switch self {
        case .attack:
            attack(user: user, target: target[0])
        case .heal:
            heal(user: user, target: target[0])
        case .multiAttack:
            multiAttack(user: user, target: target)
        case .multiHeal:
            multiHeal(user: user, target: target)
        case .diversion:
            diversion(user: user, target: target[0])
        }
    }

    /// Use attack.
    /// - parameter user: The character which use the skill.
    /// - parameter target: The character which will be target of the skill.
    private func attack(user: Character, target: Character) {
        // chooses a random number between strength / 2 and strength, and substracts this number to the target healthpoints
        var injuriesPoints = Int.random(in: user.strength/2...user.strength)
        if injuriesPoints > target.healthPoints {
            injuriesPoints = target.healthPoints
        }
        target.injuriesPoints += injuriesPoints
        print("Sustained injuries points : \(injuriesPoints)")
        if target.isDead {
            print("🎖 \(target.name) died ! 💀")
        }
    }

    /// Use heal.
    /// - parameter user: The character which use the skill.
    /// - parameter target: The character which will be target of the skill.
    private func heal(user: Character, target: Character) {
        // checks if healthcare points + target's healthpoints are less than the maximum healthpoints, and add healthcare points to the target healthpoints
        var healPoints: Int = Int.random(in: user.healthCare/2...user.healthCare)
        if healPoints + target.healthPoints > target.type.maxHealthPoints() {
            healPoints = target.type.maxHealthPoints() - target.healthPoints
        }
        target.healPoints += healPoints
        print("Received heal points : \(healPoints)")
    }

    /// Use multiAttack.
    /// - parameter user: The character which use the skill.
    /// - parameter target: The characters which will be targets of the skill.
    private func multiAttack(user: Character, target: [Character]) {
        // substract a third of the character's strength to the healthpoints of each alive character of the ennemy
        let injuriesPoints = user.strength
        for character in target {
            if character.isDead == false {
                var thirdInjuriesPoints = injuriesPoints / 3
                if thirdInjuriesPoints > character.healthPoints {
                    thirdInjuriesPoints = character.healthPoints
                }
                character.injuriesPoints += thirdInjuriesPoints
                print("Sustained injuries points : \(thirdInjuriesPoints) for \(character.name)")
                if character.isDead {
                    print("🎖 \(character.name) died ! 💀")
                }
            }
        }
        // special skill is used, next round this character won't be able to use it again
        user.specialSkillIsUsed()
    }

    /// Use multiHeal.
    /// - parameter user: The character which use the skill.
    /// - parameter target: The characters which will be targets of the skill.
    private func multiHeal(user: Character, target: [Character]) {
        // for each alive character of the choosenplayer, checks if a third of healthcare points + target's healthpoints are less than its maximum healthpoints, and add a third of healthcare points to the target healthpoints
        let thirdHealthCare: Int = user.healthCare / 3
        for character in target {
            var healPoints: Int = thirdHealthCare
            if character.isDead == false {
                if healPoints + character.healthPoints >  character.type.maxHealthPoints() {
                    healPoints = character.type.maxHealthPoints() - character.healthPoints
                }
                character.healPoints += healPoints
                print("Received heal points : \(healPoints) for \(character.name)")
            }
        }
        // special skill is used, next round this character won't be able to use it again
        user.specialSkillIsUsed()
    }

    /// Use diversion.
    /// - parameter user: The character which use the skill.
    /// - parameter target: The character which will be target of the skill.
    private func diversion(user: Character, target: Character) {
        // chooses a random number of rounds during which the target will be diverted
        let randomRounds: Int = Int.random(in: 2...4)
        target.diversionRounds = randomRounds
        print("\(target.name) is diverted for \(randomRounds) rounds.")
        // special skill is used, next round this character won't be able to use it again
        user.specialSkillIsUsed()
    }
}
