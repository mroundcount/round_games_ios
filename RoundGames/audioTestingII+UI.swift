//
//  audioTestingII+UI.swift
//  RoundGames
//
//  Created by Michael Roundcount on 5/14/24.
//

import UIKit
import Foundation

extension audioTestingII {
    
    func setUpStartBtn() {
        startBtn.setTitle("Start", for: UIControl.State.normal)
        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        startBtn.backgroundColor = UIColor.white
        startBtn.layer.cornerRadius = 20
        startBtn.clipsToBounds = true
        startBtn.setTitleColor(.white, for: UIControl.State.normal)
        startBtn.backgroundColor = UIColor.blue
    }
    
    func setUpFeedbackLbl() {
        feedbackLbl.text = "Feedback... Nothing yet"
        feedbackLbl.textColor = UIColor.black
        feedbackLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    func setUpOutputLbl() {
        outputLbl.text = "Output"
        outputLbl.textColor = UIColor.black
        outputLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
}
