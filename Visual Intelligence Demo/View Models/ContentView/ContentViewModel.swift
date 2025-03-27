//
//  ContentViewModel.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/21/25.
//

import Foundation
import AVFoundation
import SwiftUI

enum ClassifierStatus {
	case initial
	case waiting
	case completed
	case inputRequired
	case awaitingOpenAIResponse
	case awaitingGoogleVisionResponse
}

@Observable
class ContentViewModel: NSObject, AVCapturePhotoCaptureDelegate {
	
	// MARK: Overlays
	var presentingWelcome: Bool = true
	var presentingHistory: Bool = false
	var presentingDeveloperOptions: Bool = false
	
	// MARK: Status
	var classificationStatus: ClassifierStatus = .initial
	
	// MARK: Vision
	var presentingExternalClassificationOptions: Bool = false
	var onDeviceClassification: VisionClassificationKnowledge? = nil
	
	// MARK: Camera
	var capturingPhoto: Bool = false
	var cameraSession = AVCaptureSession()
	var cameraPreview: AVCaptureVideoPreviewLayer!
	var capturedOutput = AVCapturePhotoOutput()
	var capturedData: Data? = nil
	private var capturedImageContinuation: CheckedContinuation<Data, Error>?
	enum CapturedDataConversionError: Error {
		case failed
	}
	var maskedImage: UIImage? = nil
	
	// MARK: Event
	var presentingEventView: Bool = false
	var eventDate: Date? = nil
	var eventTitle: String? = nil
	
	// MARK: Speech
	let synthesizer = AVSpeechSynthesizer()
	var allRecognizedText: String? = nil
	var presentingTextToSpeechView: Bool = false
	
	// MARK: OpenAI
	var presentingOpenAIPermissionsView: Bool = false
	var openAIResponse: OpenAIResponse? = nil
	var askingOpenAIQuestion: Bool = false
	var openAIQuestion: String = ""
	var openAIMissingAPIAlert: Bool = false
	var openAIAPIError: Bool = false
	
	// MARK: GoogleVision
	var presentingGoogleVisionPermissionsView: Bool = false
	var presentingGoogleSimilarImages: Bool = false
	var googleSimilarImagesResponse: GoogleVisionResponse? = nil
	var googleVisionMissingAPIAlert: Bool = false
	var googleVisionAPIError: Bool = false
	
	
	// MARK: Camera Configuration
	
	private func setup () {
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
	
	// MARK: Camera Capture
	
	public func capture () async throws {
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
		capturingPhoto = false
	}
	
	// MARK: Close Classification
	
	public func close () {
		
		classificationStatus = .initial
		onDeviceClassification = nil
		eventDate = nil
		eventTitle = nil
		openAIResponse = nil
		allRecognizedText = nil
		synthesizer.stopSpeaking(at: .immediate)
		
		presentingEventView = false
		presentingExternalClassificationOptions = false
		presentingTextToSpeechView = false
		
		presentingGoogleSimilarImages = false
		googleSimilarImagesResponse = nil
	}
	
}
