//
//  PreviousResponse.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/11/25.
//

import SwiftUI
import SwiftData

@Model
final class PreviousResponse {
	
	var imageData: Data
	var visionClassification: VisionClassificationKnowledge?
	var openAIReponse: String?
	var googleVisionResponse: GoogleVisionResponse?
    var timestamp: Date
    
	init(imageData: Data, openAIResponse: String) {
		self.imageData = imageData
		self.openAIReponse = openAIResponse
		self.timestamp = Date()
	}
	
	init(imageData: Data, visionClassification: VisionClassificationKnowledge) {
		self.imageData = imageData
		self.visionClassification = visionClassification
		self.timestamp = Date()
	}
	
	init(imageData: Data, googleVisionResponse: GoogleVisionResponse) {
		self.imageData = imageData
		self.googleVisionResponse = googleVisionResponse
		self.timestamp = Date()
	}
}
