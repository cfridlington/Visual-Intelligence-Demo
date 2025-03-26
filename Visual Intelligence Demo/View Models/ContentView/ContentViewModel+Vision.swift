//
//  ContentViewModel+Vision.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import SwiftUI
import Vision

extension ContentViewModel {
	
	public func performVisionAnalysis () async {
		
		do {
			try await capture()
			
			classificationStatus = .waiting
			
			let request = ClassifyImageRequest()
			var results: ClassifyImageRequest.Result
			
			if let mask = try await isolateImageSubject(data: capturedData!) {
				maskedImage = UIImage(pixelBuffer: mask)
				results = try await request.perform(on: mask)
			} else {
				results = try await request.perform(on: capturedData!)
			}
			
			results.sort(by: { $0.confidence > $1.confidence })
			
			let categories = [
				"plant",
				"flower",
				"canine",
				"dog",
				"feline",
				"animal",
				"mammal",
				"ungulates"
			]
			
			let filteredResults = results.filter({ !categories.contains($0.identifier) })
			
			let identifier = filteredResults.first?.identifier ?? ""
			
			let classifications = VisionClassificationKnowledgeBase()
			
			if let match = classifications.plants.first(where: { $0.name == identifier }) {
				onDeviceClassification = match
			}
			
			if let match = classifications.dogs.first(where: { $0.name == identifier }) {
				onDeviceClassification = match
			}
			
			if let match = classifications.animals.first(where: { $0.name == identifier }) {
				onDeviceClassification = match
			}
			
			if onDeviceClassification == nil {
				classificationStatus = .inputRequired
				presentingExternalClassificationOptions = true
			} else {
				classificationStatus = .completed
			}
			
		} catch {
			print("Error")
		}
	}
	
	private func isolateImageSubject (data: Data) async throws -> CVPixelBuffer? {
		
		let request = GenerateForegroundInstanceMaskRequest()
		let result = try await request.perform(on: data)
		let handler = ImageRequestHandler(data)
		let mask = try result?.generateMaskedImage(for: result?.allInstances ?? [], imageFrom: handler)
		
		return mask
	}

	public func performTextAnalysis () async {
		
		do {
			try await capture()
			
			var request = RecognizeTextRequest()
			request.recognitionLevel = .accurate
			
			let results = try await request.perform(on: capturedData!)
			
			extractEventDetails(from: results)
			
			if !results.isEmpty {
				let allRecognizedLinesOfText = results.map({ $0.topCandidates(1).first?.string ?? "" })
				allRecognizedText = allRecognizedLinesOfText.joined(separator: " ")
			}
			
		} catch {
			print("Error")
		}
		
	}
	
	private func extractEventDetails(from recognizedText: [RecognizedTextObservation]) {
		
		var maxTitleArea: CGFloat = 0
		var maxDateArea: CGFloat = 0
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US")
		
		for observation in recognizedText {
			
			guard let observedText = observation.topCandidates(1).first?.string else { continue }
			
			let area = observation.boundingBox.height * observation.boundingBox.width
			
			let numbersWithOrdinals = #"(?<=[0-9])(st|nd|rd|th)"#
			let observedTextWithoutOrdinals = observedText.replacingOccurrences(of: numbersWithOrdinals, with: "")
			
			let decodingFormats = [
				"MM dd", "MM dd 'at' ha", "MM dd 'at' h:mma",  "ha 'on' MM dd",  "h:mma 'on' MM dd",
				"MM-dd", "MM-dd 'at' ha", "MM-dd 'at' h:mma",  "ha 'on' MM-dd",  "h:mma 'on' MM-dd",
				"MM/dd", "MM/dd 'at' ha", "MM/dd 'at' h:mma",  "ha 'on' MM/dd",  "h:mma 'on' MM/dd",
				"MM dd yy", "MM dd yy 'at' ha", "MM dd yy 'at' h:mma",  "ha 'on' MM dd yy",  "h:mma 'on' MM dd yy",
				"MM-dd-yy", "MM-dd-yy 'at' ha", "MM-dd-yy 'at' h:mma",  "ha 'on' MM-dd-yy",  "h:mma 'on' MM-dd-yy",
				"MM/dd/yy", "MM/dd/yy 'at' ha", "MM/dd/yy 'at' h:mma",  "ha 'on' MM/dd/yy",  "h:mma 'on' MM/dd/yy",
				"MM dd yyyy", "MM dd yyyy 'at' ha", "MM dd yyyy 'at' h:mma",  "ha 'on' MM dd yyyy",  "h:mma 'on' MM dd yyyy",
				"MM-dd-yyyy", "MM-dd-yyyy 'at' ha", "MM-dd-yyyy 'at' h:mma",  "ha 'on' MM-dd-yyyy",  "h:mma 'on' MM-dd-yyyy",
				"MM/dd/yyyy", "MM/dd/yyyy 'at' ha", "MM/dd/yyyy 'at' h:mma",  "ha 'on' MM/dd/yyyy",  "h:mma 'on' MM/dd/yyyy",
				"MMM dd", "MMM dd 'at' ha", "MMM dd 'at' h:mma",  "ha 'on' MMM dd",  "h:mma 'on' MMM dd",
				"MMM dd yy", "MMM dd yy 'at' ha", "MMM dd yy 'at' h:mma",  "ha 'on' MMM dd yy",  "h:mma 'on' MMM dd yy",
				"MMM dd yyyy", "MMM dd yyyy 'at' ha", "MMM dd yyyy 'at' h:mma",  "ha 'on' MMM dd yyyy",  "h:mma 'on' MMM dd yyyy",
				"MMMM dd", "MMMM dd 'at' ha", "MMMM dd 'at' h:mma",  "ha 'on' MMMM dd",  "h:mma 'on' MMMM dd",
				"MMMM dd yy", "MMMM dd yy 'at' ha", "MMMM dd yy 'at' h:mma",  "ha 'on' MMMM dd yy",  "h:mma 'on' MMMM dd yy",
				"MMMM dd yyyy", "MMMM dd yyyy 'at' ha", "MMMM dd yyyy 'at' h:mma",  "ha 'on' MMMM dd yyyy",  "h:mma 'on' MMMM dd yyyy",
			]
			
			var observedTextIsDate: Bool = false
			
			for format in decodingFormats {
				
				dateFormatter.dateFormat = format
				guard var date = dateFormatter.date(from: observedTextWithoutOrdinals) else { continue }
				
				observedTextIsDate = true
				
				let calendar = Calendar.current
				
				if calendar.component(.year, from: date) == 2000 {
					let currentYear = calendar.component(.year, from: Date())
					var components = calendar.dateComponents([.month, .day, .hour, .minute], from: date)
					components.year = currentYear
					date = calendar.date(from: components) ?? date
				}
				
				if area > maxDateArea {
					eventDate = date
					maxDateArea = area
				}
			}
			
			if (!observedTextIsDate) {
				if area > maxTitleArea {
					eventTitle = observation.topCandidates(1).first?.string ?? nil
					maxTitleArea = area
				}
			}
			
		}
		
	}
}
