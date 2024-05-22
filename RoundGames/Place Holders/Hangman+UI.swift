//
//  Hangman+UI.swift
//  RoundGames
//
//  Created by Michael Roundcount on 4/1/24.
//

import Foundation
import UIKit
import GameKit

extension Hangman {
    
    func setUpUI() {
        scoreLbl.text = "We're not using this"
        guessTextField.layer.borderWidth = 1.0
        
        submitBtn.setTitle("Submit", for: UIControl.State.normal)
        
        //More for resets
        usedLettersLbl.text = "Guessed Letters"
        guessTextField.text = ""
        wordLbl.text = maskedWord
        
        livesRemaining = 10
        guessesRemainingLbl.text = "\(livesRemaining) lives left"
    }
    
    func clearArrays() {
        wordLetterArray.removeAll()
        wordStrings.removeAll()
        maskedWordArray.removeAll()
        previousLetters.removeAll()
    }
    
    //Limiting the text field input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString = (guessTextField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
    
}

extension UILabel {
    // Typing animation
    func typingTextAnimation(text: String, timeInterval: Double) {
        self.text = ""
        self.alpha = 0
        var charIndex = 0.0
        for letter in text  {
            Timer.scheduledTimer(withTimeInterval: timeInterval * charIndex, repeats: false) { (timer) in
                self.text?.append(letter)
            }
            charIndex += 1
        }
        UIView.animate(withDuration: 1.0) {
            self.alpha = 1.0
        }
    }
}
