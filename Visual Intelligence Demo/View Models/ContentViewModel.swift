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
		
		public func capture () {
			DispatchQueue.global(qos: .background).async {
				self.capturedOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
			}
		}
		
		internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
			if error != nil {
				return
			}
			
			guard let data = photo.fileDataRepresentation() else { return }
			self.capturedData = data
			
			print("Picture Taken")
		}
	}
}
