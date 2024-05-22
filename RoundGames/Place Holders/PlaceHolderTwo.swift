//
//  PlaceHolderTwo.swift
//  RoundGames
//
//  Created by Michael Roundcount on 3/26/24.
//

import UIKit
import Foundation

class PlaceHolderTwoViewController: UIViewController {
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var loadBtn: UIButton!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var startTimer: UIButton!
    @IBOutlet weak var stopTimer: UIButton!
    @IBOutlet weak var addTime: UIButton!
    @IBOutlet weak var subtractTime: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    //Key value storage for....
    //https://betterprogramming.pub/data-persistence-nsubiquitouskeyvaluestore-9cf4f97cd50c
    
    //Timer Logic
    //https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f
    
    var keyValStore = NSUbiquitousKeyValueStore()
    
    //For timer logic
    var seconds = 60
    var buh: String?
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpvalueTextFieldValueTextField()
        setUpBtn()
        
        timerCheck()
        updateDataLbl()
    }
    
    func timerCheck() {
        if keyValStore.string(forKey: "timerData") == "" {
            return
        } else {
            buh = keyValStore.string(forKey: "timerData")!
            seconds = Int(buh!)!
            updateDataLbl()
        }
    }
    
    func updateDataLbl() {
        dataLbl.text = "\(seconds)"
    }
    
    func updateKeyValue() {
        keyValStore.set(seconds, forKey: "timerData")
        keyValStore.synchronize()
    }
    
    @IBAction func saveBtnDidTap(_ sender: Any) {
        print("Saved")
        let data = self.valueTextField.text
        
        keyValStore.set(data, forKey: "timerData")
        keyValStore.synchronize()
    }
    
    @IBAction func loadBtnDidTap(_ sender: Any) {
        print("Loading...")
        let timerData = keyValStore.string(forKey: "timerData")
        dataLbl.text = timerData
    }
    
    @IBAction func startTimeBtnDidTap(_ sender: Any) {
        print("Starting timer")
        runTimer()
    }
    
    @IBAction func stopTimeBtnDidTap(_ sender: Any) {
        print("Stopping timer")
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            stopTimer.setTitle("Resume", for: UIControl.State.normal)
        } else {
            runTimer()
            self.resumeTapped = false
            stopTimer.setTitle("Pause", for: UIControl.State.normal)
        }
    }
    
    @IBAction func addTimeBtnDidTap(_ sender: Any) {
        print("Adding time")
        seconds += 10
    }
    
    @IBAction func subtractTimeBtnDidTap(_ sender: Any) {
        print("Subtracting time")
        seconds -= 10
    }
    
    @IBAction func resetBtnDidTap(_ sender: UIButton) {
        timer.invalidate()
        seconds = 60
        updateDataLbl()
        
        updateKeyValue()
    }
    
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(PlaceHolderTwoViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        updateDataLbl()
        
        updateKeyValue()
        
    }
    
    func setUpvalueTextFieldValueTextField() {
        valueTextField.layer.borderWidth = 1
        valueTextField.layer.borderColor = UIColor.blue.cgColor
        valueTextField.layer.cornerRadius = 20
        valueTextField.clipsToBounds = true
        valueTextField.backgroundColor = UIColor.clear
        valueTextField.borderStyle = .none
        
        let placeholderAttr = NSAttributedString(string: "Enter a new value", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        valueTextField.attributedPlaceholder = placeholderAttr
        valueTextField.textColor = UIColor.black
    }
    
    func setUpBtn() {
        saveBtn.setTitle("Save", for: UIControl.State.normal)
        loadBtn.setTitle("Load", for: UIControl.State.normal)
        startTimer.setTitle("Start", for: UIControl.State.normal)
        stopTimer.setTitle("Pause", for: UIControl.State.normal)
        addTime.setTitle("Add", for: UIControl.State.normal)
        subtractTime.setTitle("Subtract", for: UIControl.State.normal)
    }
    
}
