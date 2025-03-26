//
//  ContentViewModel+OpenAI.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import SwiftUI

extension ContentViewModel {
	public func sendQueryToOpenAI () async {
		
		let permissionGranted = UserDefaults.standard.bool(forKey: "permissionGrantedOpenAI")
		
		if !permissionGranted {
			presentingOpenAIPermissionsView = true
			return
		}
		
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
		
		do {
			let (data, _) = try await URLSession.shared.upload(for: request, from: encodedData)
			
			openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
			
		} catch {
			print("request failed: \(error.localizedDescription)")
		}
	}
}
