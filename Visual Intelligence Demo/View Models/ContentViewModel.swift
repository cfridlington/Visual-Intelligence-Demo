//
//  ContentViewModel.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/21/25.
//

import Foundation
import AVFoundation
import SwiftUI

extension ContentView {
	
	@Observable
	class ViewModel: NSObject, AVCapturePhotoCaptureDelegate {
		
		var presentingWelcome: Bool = true
		var presentingHistory: Bool = false
		var presentingDeveloperOptions: Bool = false
		
		var classificationStatus: ClassifierStatus = .completed
		var onDeviceClassification: String? = nil
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
		
		private func setup() {
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
		
		public func performLocalClassification() async {
			
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
					onDeviceClassification = sorted.first!.key
				} else {
					withAnimation {
						presentingExternalClassificationOptions = true
					}
				}
				
				classificationStatus = .completed
				
			} catch {
				print("Error Prediciting: \(error.localizedDescription)")
			}
			
		}

		
	}
}
