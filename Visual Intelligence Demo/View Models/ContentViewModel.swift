//
//  ContentViewModel.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/21/25.
//

import Foundation
import AVFoundation
import SwiftUI
import Vision

extension ContentView {
	
	@Observable
	class ViewModel: NSObject, AVCapturePhotoCaptureDelegate, AVSpeechSynthesizerDelegate {
		
		var presentingWelcome: Bool = true
		var presentingHistory: Bool = false
		var presentingDeveloperOptions: Bool = false
		
		var classificationStatus: ClassifierStatus = .completed
		var onDeviceClassification: LocalClassification? = nil
		private var capturedImageContinuation: CheckedContinuation<Data, Error>?
		enum CapturedDataConversionError: Error {
			case failed
		}
		
		var presentingExternalClassificationOptions: Bool = false
		
		var askingQuestion: Bool = false
		var question: String = ""
		
		var isPhotoCaptured: Bool = false
		var cameraSession = AVCaptureSession()
		var cameraPreview: AVCaptureVideoPreviewLayer!
		var capturedOutput = AVCapturePhotoOutput()
		var capturedData: Data? = nil
		
		var presentingEventView: Bool = false
		
		var eventDate: Date? = nil
		var eventTitle: String? = nil
	
		var openAIQueryStatus: OpenAIQueryStatus = .complete
		var prompt: String = """
			Tell me some information about the subject of this image. Rather than describing the contents provide non-trivial information about the subject.
		"""
		var openAIResponse: OpenAIResponse? = nil
		
		let synthesizer = AVSpeechSynthesizer()
		var allRecognizedText: String? = nil
		var presentingTextToSpeechView: Bool = false
		
		private func setup () {
			print("Setup")
			do {
				cameraSession.beginConfiguration()
				let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
				let input = try AVCaptureDeviceInput(device: device!)
				
				if cameraSession.canAddInput(input) {
					cameraSession.addInput(input)
				}
				
				if cameraSession.canAddOutput(capturedOutput) {
					cameraSession.addOutput(capturedOutput)
				}
				
				cameraSession.commitConfiguration()
				
			} catch {
				print(error.localizedDescription)
			}
		}
		
		public func checkPermissions () {
			switch AVCaptureDevice.authorizationStatus(for: .video) {
				case .authorized:
					setup()
				case .notDetermined:
					AVCaptureDevice.requestAccess(for: .video) { granted in
						if granted {
							self.setup()
						}
					}
				case .denied:
					return
				case .restricted:
					return
				@unknown default:
					return
			}
		}
		
		public func capture () async throws {
			
			capturedData = nil
			
			capturedData = try await withCheckedThrowingContinuation { continuation in
				capturedImageContinuation = continuation
				self.capturedOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
			}
		}
		
		internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
			if let error = error {
				capturedImageContinuation?.resume(throwing: error)
				return
			}
			
			guard let data = photo.fileDataRepresentation() else {
				capturedImageContinuation?.resume(throwing: CapturedDataConversionError.failed)
				return
			}
			
			capturedImageContinuation?.resume(returning: data)
		}
		
		public func performLocalClassification () async {
			
			onDeviceClassification = nil
			
			do {
				try await capture()
			} catch {
				print("Error")
			}
			
			let image = UIImage(data: capturedData!)!
			
			let confidenceThreshold = 0.8
			
			classificationStatus = .waiting
			
			guard let resizedImage = image.resizeImageTo(size: CGSize(width: 360, height: 360)) else { return }
			guard let buffer = resizedImage.convertToBuffer() else { return }
			
			do {
				let model = try VisualIntelligenceKnowledge()
				let output = try model.prediction(image: buffer)
				
				let sorted = output.targetProbability.sorted { $0.value > $1.value }
				
				if (sorted.first?.value ?? 0 > confidenceThreshold) {
//					onDeviceClassification = sorted.first!.key
					classificationStatus = .completed
				} else {
					withAnimation {
						presentingExternalClassificationOptions = true
					}
				}
				
			} catch {
				print("Error Prediciting: \(error.localizedDescription)")
			}
			
		}
		
		public func cancelClassification () {
			presentingExternalClassificationOptions = false
			onDeviceClassification = nil
			classificationStatus = .completed
		}
		
		public func performTextAnalysis () async {
			
			classificationStatus = .waiting
			
			do {
				try await capture()
				
				var request = RecognizeTextRequest()
				request.recognitionLevel = .accurate
				
				let results = try await request.perform(on: capturedData!)
				
				extractEventDetails(from: results)
				
				let allRecognizedLinesOfText = results.map({ $0.topCandidates(1).first?.string ?? "" })
				allRecognizedText = allRecognizedLinesOfText.joined(separator: " ")
				
				
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
		
		public func performVisionAnalysis () async {
			
			onDeviceClassification = nil
			classificationStatus = .waiting
			
			do {
				try await capture()
				let mask = try await isolateImageSubject(data: capturedData!)
				
				let request = ClassifyImageRequest()
				var results = try await request.perform(on: mask)
				
				results.sort(by: { $0.confidence > $1.confidence })
				
				let categories = [
					"plant",
					"flower",
					"canine",
					"dog",
					"feline",
					"animal",
					"maMMal",
					"ungulates"
				]
				let filteredResults = results.filter({ !categories.contains($0.identifier) })
				
				let identifier = filteredResults.first?.identifier ?? ""
				let classifications = LocalClassificationTypes()
				
				print(identifier)
				
				if let match = classifications.plants.first(where: { $0.name == identifier }) {
					onDeviceClassification = match
					print(classifications.plants.count)
				}
				
				if let match = classifications.dogs.first(where: { $0.name == identifier }) {
					onDeviceClassification = match
				}
				
				if let match = classifications.animals.first(where: { $0.name == identifier }) {
					onDeviceClassification = match
					print(classifications.animals.count)
				}
				
				if onDeviceClassification == nil {
					presentingExternalClassificationOptions = true
				}
				
			} catch {
				print("Error")
			}
		}
		
		private func isolateImageSubject (data: Data) async throws -> CVPixelBuffer {
			
			let request = GenerateForegroundInstanceMaskRequest()
			let result = try await request.perform(on: data)
			let handler = ImageRequestHandler(data)
			let mask = try result!.generateMaskedImage(for: result!.allInstances, imageFrom: handler)
			
			return mask
		}
		
		public func sendQueryToOpenAI () async {
			
			guard let path = Bundle.main.path(forResource: "API-Keys", ofType: "plist") else { fatalError("Failed to get path for API Keys") }
			let plistURL = URL(fileURLWithPath: path)
			let plistData = try! Data(contentsOf: plistURL)
			guard let plist = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainers, format: nil) as? [String:String] else { fatalError("Failed to decode plist") }
			guard let accessKey = plist["OpenAI"] else { fatalError("Key not found in plist") }
			
			let text = prompt + question == "" ? "" : " Please also tailor the information to answer the following: \(question)"
			guard let image = UIImage(data: capturedData!) else { return }
			
			let data = OpenAIRequest(model: "gpt-4o-mini", messages: [OpenAIRequestMessage(content: [OpenAIRequestMessageContentText(text: text), OpenAIRequestMessageContentImage(image: image)])])
			guard let encodedData = try? JSONEncoder().encode(data) else { return }
			
			let url = URL(string: "https://api.openai.com/v1/chat/completions")!
			var request = URLRequest(url: url)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.setValue("Bearer \(accessKey)", forHTTPHeaderField: "Authorization")
			request.httpMethod = "POST"
			
			withAnimation {
				openAIQueryStatus = .waiting
			}
			
			do {
				let (data, _) = try await URLSession.shared.upload(for: request, from: encodedData)
				
				openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
				
				withAnimation {
					openAIQueryStatus = .complete
				}
				
			} catch {
				print("request failed: \(error.localizedDescription)")
			}
		}
		
		public func close () {
			
			classificationStatus = .completed
			onDeviceClassification = nil
			eventDate = nil
			eventTitle = nil
			openAIResponse = nil
			openAIQueryStatus = .complete
			allRecognizedText = nil
			synthesizer.stopSpeaking(at: .immediate)
			
			presentingEventView = false
			presentingExternalClassificationOptions = false
			presentingTextToSpeechView = false
		}
		
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
}
