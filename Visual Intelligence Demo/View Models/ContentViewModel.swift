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
	class ViewModel: NSObject, AVCapturePhotoCaptureDelegate {
		
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
					"mammal",
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
		
	}
}
