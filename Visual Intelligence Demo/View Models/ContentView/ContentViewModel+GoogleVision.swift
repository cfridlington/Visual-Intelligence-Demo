//
//  ContentViewModel+GoogleVision.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import SwiftUI

extension ContentViewModel {
	
	public func captureAndRequestSimilarImagesFromGoogle () async {
		do {
			try await capture()
			
			classificationStatus = .awaitingGoogleVisionResponse
			
			if let mask = try await isolateImageSubject(data: capturedData!) {
				maskedImage = UIImage(pixelBuffer: mask)
			}
			
			await requestSimilarImagesFromGoogle()
			
		} catch {
			fatalError("Cannot capture image")
		}
	}
	
	public func requestSimilarImagesFromGoogle() async {
		
		let permissionGranted = UserDefaults.standard.bool(forKey: "permissionGrantedGoogleVision")
		
		if !permissionGranted {
			presentingGoogleVisionPermissionsView = true
			return
		}
		
		guard let accessKey = UserDefaults.standard.object(forKey:"googleVisionAPIKey") as? String else {
			googleVisionMissingAPIAlert = true
			return
		}
		
		if accessKey == "" {
			googleVisionMissingAPIAlert = true
			return
		}
		
		classificationStatus = .awaitingGoogleVisionResponse
		
		let requestData = GoogleVisionRequest(requests: [GoogleVisionRequestMessageContent(image: GoogleVisionRequestMessageImage(image: (maskedImage ?? UIImage(data: capturedData!))!), features: [GoogleVisionRequestMessageFeature(maxResults: 20)])])
		guard let encodedData = try? JSONEncoder().encode(requestData) else { return }
		
		guard let bundleID = Bundle.main.bundleIdentifier else { return }
		
		let url = URL(string: "https://vision.googleapis.com/v1/images:annotate")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("\(accessKey)", forHTTPHeaderField: "X-goog-api-key")
		request.setValue("\(bundleID)", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
		request.httpMethod = "POST"
		
		do {
			let (data, _) = try await URLSession.shared.upload(for: request, from: encodedData)
			
			let response = try JSONDecoder().decode(GoogleVisionResponse.self, from: data)
			
			classificationStatus = .completed
			googleSimilarImagesResponse = response
			
		} catch {
			print("request failed: \(error.localizedDescription)")
		}
		
		
		presentingGoogleSimilarImages = true
	}
}
