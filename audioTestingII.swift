//
//  audioTestingII.swift
//  
//
//  Created by Michael Roundcount on 5/14/24.
//

import UIKit
import Foundation
import Speech

//http://www.avikam.com/2016/09/17/sfspeechrecognizer-tutorial/
//^^^ first attempt.... not really impressed. It only captures one word at a time and does not loop.

//https://delasign.com/blog/swift-speech-recognition-loop/?utm=swift-starter-project
//^^^ Current Attempt
//https://www.delasign.com/blog/swift-speech-recognition/
//The Actual code for take two

class audioTestingII: UIViewController {
    
    @IBOutlet weak var feedbackLbl: UILabel!
    @IBOutlet weak var outputLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Request Speech Authorization
        SpeechCoordinator.shared.requestAuthorization()
    }
    
    func setUpUI(){
        setUpStartBtn()
        setUpFeedbackLbl()
        setUpOutputLbl()
    }
    
    
    @IBAction func startBtnDidTap(_ sender: Any) {
        print("Start Button Pressed")
    }
    
 
    
}
