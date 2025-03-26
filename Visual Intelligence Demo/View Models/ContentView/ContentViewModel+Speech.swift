//
//  ContentViewModel+Speech.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import Foundation
import AVFoundation

extension ContentViewModel: AVSpeechSynthesizerDelegate {
	public func speakRecognizedText() {
		
		synthesizer.delegate = self
		presentingTextToSpeechView = true
		
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playback, mode: .default, options: [])
			try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
			
			let utterance = AVSpeechUtterance(string: allRecognizedText ?? "")
			
			let availableVoices = AVSpeechSynthesisVoice.speechVoices()
			var selectedVoice = AVSpeechSynthesisVoice()
			
			for voice in availableVoices {
				
				if voice.quality == .enhanced && voice.language == "en-US" {
					selectedVoice = voice
				}
			}
			
			utterance.voice = selectedVoice
			utterance.rate = 0.55
			utterance.pitchMultiplier = 0.8
			utterance.postUtteranceDelay = 0.2
			synthesizer.speak(utterance)
		} catch {
			print("Error configuring audio session: \(error)")
		}
		
	}
	
	public func playPauseSpokenText () {
		if synthesizer.isPaused {
			synthesizer.continueSpeaking()
		} else if synthesizer.isSpeaking {
			synthesizer.pauseSpeaking(at: .immediate)
		}
	}
}
