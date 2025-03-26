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
		
		guard let accessKey = UserDefaults.standard.object(forKey:"openAIAPIKey") as? String else {
			openAIMissingAPIAlert = true
			return
		}
		
		if accessKey == "" {
			openAIMissingAPIAlert = true
			return
		}
		
		let text = prompt + openAIQuestion == "" ? "" : " Please also tailor the information to answer the following: \(openAIQuestion)"
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
			openAIAPIError = true
			print("request failed: \(error.localizedDescription)")
		}
	}
}
