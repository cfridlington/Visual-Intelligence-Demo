//
//  File.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/12/25.
//

import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
	
	@Published var isTaken = false
	@Published var session = AVCaptureSession()
	var preview: AVCaptureVideoPreviewLayer!
	@Published var output = AVCapturePhotoOutput()
	@Published var capturedData: Data? = nil
	
	private func setup() {
		do {
			session.beginConfiguration()
			let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
			let input = try AVCaptureDeviceInput(device: device!)
			
			if session.canAddInput(input) {
				session.addInput(input)
			}
			
			if session.canAddOutput(output) {
				session.addOutput(output)
			}
			
			session.commitConfiguration()
			
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
			self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
//			self.session.stopRunning()
		}
	}
	
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		if error != nil {
			return
		}
		
		guard let data = photo.fileDataRepresentation() else { return }
		self.capturedData = data
		
		print("Picture Taken")
	}
	
}
