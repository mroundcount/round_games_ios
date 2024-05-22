//
//  audioCommands.swift
//  RoundGames
//
//  Created by Michael Roundcount on 4/4/24.
//

import UIKit
import Foundation
import Speech

//https://www.youtube.com/watch?v=Y9-8EwwSafg

class AudioCommands: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var spechLbl: UILabel!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var startBtn: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var timer : Timer?
    var submissionArray = [String]()
    var checker = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBtn.setTitle("Start Speaking", for: .normal)
        
        speechRecognizer?.delegate = self

        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied:
                print("User denied access to speech recognition")
            case .restricted:
                print("Restricted")
            case .notDetermined:
                print("Speech recognition not yet authorized")
            @unknown default:
                fatalError("Unhandled case in requestAuthorization")
            }
        }
    }
    
    @IBAction func startBtnDidTap(sender: UIButton) {
        if audioEngine.isRunning {
            stopRecording()
        } else {
            try? startRecording()
        }
    }
    
    func startRecording() throws {
        print("checker status: \(checker)")
        startBtn.setTitle("Stop", for: .normal)
                
        recognitionTask?.cancel()
        recognitionTask = nil
        
        self.submissionArray.removeAll()
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                let str: String = result.bestTranscription.formattedString.lowercased()
                
                print("String: \(str)")
                self.spechLbl.text = str
                
                if str.lowercased().contains("stop"){
                    print("stop listening")
                    self.stopRecording()
                }
                if self.checker == 0 {
                    if str.lowercased().contains("ready"){
                        print("Ready for letter")
                        //self.audioEngine.inputNode.removeTap(onBus: 0)
                        self.stageForSubmission()
                        
                    } else if str.lowercased().contains("green"){
                        self.viewColor.backgroundColor = UIColor.green
                    } else if str.lowercased().contains("red"){
                        self.viewColor.backgroundColor = UIColor.red
                    } else if str.lowercased().contains("yellow"){
                        self.viewColor.backgroundColor = UIColor.yellow
                    }
                }
                
                if self.checker == 1 {
                    self.startSubmissionTimer()
                    self.submissionArray.append(result.bestTranscription.formattedString.lowercased())
                    print("Submission content: \(self.submissionArray)")
                }
                
                isFinal = result.isFinal
            }
            
            //Resetting the the function and clearing out because the function default times out after 60 seconds
            if error == nil {
                self.resertAfterDefaultTimeout()
            }
            
            if error != nil || isFinal {
                //Stop the recording
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stageForSubmission() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        
        checker = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            try? self.startRecording()
        }
        
        //This is failing even though the engine is not running, it would be nice to figure out a more programtic way to make sure we can start recoring again
        /*
        if audioEngine.isRunning {
            print("Running")
            submitGuess()
        } else {
            print("NOT Running")
            try? self.startRecording()
        } */
    }
    
    func startSubmissionTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
            // Do whatever needs to be done when the timer expires
            print("Time is up")
            self.resetForNoSubmission()
        })
    }

    func resetForNoSubmission() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        
        checker = 0
        self.submissionArray.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            try? self.startRecording()
        }
    }
    
    func resertAfterDefaultTimeout() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            // Do whatever needs to be done when the timer expires
            print("Time is up")
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                try? self.startRecording()
            }
        })
    }
    


    func stopRecording() {
        print("Stop recording")
        startBtn.setTitle("Start Speaking", for: .normal)
        
        audioEngine.stop()
        recognitionRequest?.endAudio()
        
        self.spechLbl.text = ""
    }
    
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            // Endable recognition UI
        } else {
            //Disable recognition UI
        }
    }
    
}
