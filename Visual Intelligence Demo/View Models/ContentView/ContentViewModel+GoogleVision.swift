//
//  ContentViewModel+GoogleVision.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import SwiftUI

extension ContentViewModel {
	public func requestSimilarImagesFromGoogle() async {
		
		let permissionGranted = UserDefaults.standard.bool(forKey: "permissionGrantedGoogleVision")
		
		if !permissionGranted {
			presentingGoogleVisionPermissionsView = true
			return
		}
		
		guard let path = Bundle.main.path(forResource: "API-Keys", ofType: "plist") else { fatalError("Failed to get path for API Keys") }
		let plistURL = URL(fileURLWithPath: path)
		let plistData = try! Data(contentsOf: plistURL)
		guard let plist = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainers, format: nil) as? [String:String] else { fatalError("Failed to decode plist") }
		guard let accessKey = plist["GoogleVision"] else { fatalError("Key not found in plist") }
		
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
			
			print(data)
			
			if let str = String(data: data, encoding: .utf8) {
				print("Successfully decoded: \(str)")
			}
			
			let response = try JSONDecoder().decode(GoogleVisionResponse.self, from: data)
			
			googleSimilarImagesResponse = response
			
		} catch {
			print("request failed: \(error.localizedDescription)")
		}
		
		
		presentingGoogleSimilarImages = true
	}
}
