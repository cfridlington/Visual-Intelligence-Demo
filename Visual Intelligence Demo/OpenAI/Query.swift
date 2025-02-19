//
//  OpenAI.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/12/25.
//

import SwiftUI

@MainActor class OpenAIQuery: ObservableObject {
	
	private var authorization: String
	var prompt = OpenAIPrompt()
	
	@Published var status: OpenAIQueryStatus = .complete
	@Published var response: OpenAIResponse? = nil
	
	init () {
		guard let path = Bundle.main.path(forResource: "API-Keys", ofType: "plist") else { fatalError("Failed to get path for API Keys") }
		let url = URL(fileURLWithPath: path)
		let data = try! Data(contentsOf: url)
		guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String:String] else { fatalError("Failed to decode plist") }
		guard let accessKey = plist["OpenAI"] else { fatalError("Key not found in plist") }
		authorization = accessKey
	}
	
	func request (image: UIImage, question: String = "") async {
		
		let text = prompt.prompt + question == "" ? "" : " Please also tailor the information to answer the following: \(question)"
		
		let data = OpenAIRequest(model: "gpt-4o-mini", messages: [OpenAIRequestMessage(content: [OpenAIRequestMessageContentText(text: text), OpenAIRequestMessageContentImage(image: image)])])
		guard let encodedData = try? JSONEncoder().encode(data) else { return }
		
		let url = URL(string: "https://api.openai.com/v1/chat/completions")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
		request.httpMethod = "POST"
		
		withAnimation {
			status = .waiting
		}
		
		do {
			let (data, _) = try await URLSession.shared.upload(for: request, from: encodedData)
			
			response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
			
			withAnimation {
				status = .complete
			}
			
		} catch {
			print("request failed: \(error.localizedDescription)")
		}
		
	}
	
	func reset () {
		status = .complete
		response = nil
	}
}

enum OpenAIQueryStatus {
	case complete
	case waiting
	case error
}
