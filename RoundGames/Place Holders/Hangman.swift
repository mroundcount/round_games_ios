//
//  Hangman.swift
//  RoundGames
//
//  Created by Michael Roundcount on 4/1/24.
//

import Foundation
import UIKit
import SwiftUI

//NOTES: https://github.com/clarkeben/Hangman-Game/tree/master

class Hangman: UIViewController, GameProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var guessesRemainingLbl: UILabel!
    @IBOutlet weak var wordLbl: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var usedLettersLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    var livesRemaining = 10 {
        didSet {
            guessesRemainingLbl.text = "\(livesRemaining) lives left"
        }
    }
    
    let gameManager = GameDataManager()
    
    //The word we have selected broken down into individual letters into an array
    var wordLetterArray = [String]()
    var word = ""
    
    var maskedWord = ""
    //The array of the chosen word just masked
    var maskedWordArray = [String]()
    
    //The full word selected
    var wordStrings = [String]()
    var level = 0
    var levelCompleted = false
    var usedLetters = ""
    
    //Letters you guessed that are incorrect
    var incorrectLetters = [String]()
    //All letter chosen
    var previousLetters = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guessTextField.delegate = self

        clearArrays()
        setUpUI()
        gameManager.delegate = self
        gameManager.fetchData()
    }
    
    @IBAction func submitBtnDidTap(_ sender: Any) {
        enterGuess()
    }
    
    
    //Switching out letterTapped function
    func enterGuess() {
        guard let letterChosen = guessTextField.text?.lowercased() else { return }
        print("You selected \(letterChosen)")
        //Clear text field
        guessTextField.text = ""
        
        usedLetters.append(letterChosen)
        
        
        if previousLetters.contains(letterChosen) {
            let alert = UIAlertController(title: "You have already chosen this leter", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if wordLetterArray.contains(letterChosen) {
            
            for (index, letter) in wordLetterArray.enumerated() {
                if letterChosen == letter {
                    maskedWordArray[index] = letter
                }
            }
            maskedWord = maskedWordArray.joined()
            //Putting this here because I don't want it to be skipped even though it is duplicated
            previousLetters.append(letterChosen)
            
        } else {
            //You guessed wrong
            livesRemaining -= 1
            incorrectLetters.append(letterChosen)
            print("Incorrect letters: \(incorrectLetters)")
            //Putting this here because I don't want it to be skipped even though it is duplicated
            previousLetters.append(letterChosen)
        }
        
        wordLbl.text = maskedWord
        usedLettersLbl.text = incorrectLetters.joined(separator: " , ")
        // check to see if the game is completed + reset
        checkToSeeIfCompleted()
        /*
        if livesRemaining <= 1 {
            print("You're still alive")
        } */
    }
    
    func checkToSeeIfCompleted() {
        if livesRemaining > 0 {
            if maskedWord == word {
                let alert = UIAlertController(title: "You won", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                viewDidLoad()
            }
        } else {
            let alert = UIAlertController(title: "You loose", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            viewDidLoad()
        }
    }
    
    func gameDataFetched(_ data: [String]) {
        wordStrings += data
        loadWord()
    }
    
    func loadWord() {
        wordLetterArray = [String]()
        word = ""
        maskedWord = ""
        maskedWordArray = [String]()
        
        livesRemaining = 10
        
        //  Save word into an array + string
        word = wordStrings[level]
        for letter in wordStrings[level] {
            wordLetterArray.append(String(letter))
        }
        
        print("The word array: \(wordLetterArray)")
        print("The word is: \(word)")
        
        for _ in 0..<wordLetterArray.count {
            maskedWord += "?"
            maskedWordArray.append("?")
        }
        
        wordLbl.text = maskedWord
        wordLbl.typingTextAnimation(text: maskedWord, timeInterval: 0.2)
    }

}
