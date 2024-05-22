//
//  SpeechCoordinator+Availability.swift
//  RoundGames
//
//  Created by Michael Roundcount on 5/16/24.
//

import Foundation
import Speech

extension SpeechCoordinator {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            debugPrint("\(SpeechCoordinator.identifier) availabilityDidChange \(DebuggingIdentifiers.actionOrEventSucceded) Speech recognition available.")
            /*
            do {
                try self.transcribeAudio()
            } catch {
                debugPrint("\(SpeechCoordinator.identifier) availabilityDidChange \(DebuggingIdentifiers.actionOrEventFailed) Failed to start transcribing audio.")
            }*/
            self.restartAudioBuffer()
        } else {
            debugPrint("\(SpeechCoordinator.identifier) availabilityDidChange \(DebuggingIdentifiers.actionOrEventFailed) Speech recognition not available.")
        }
    }
}
