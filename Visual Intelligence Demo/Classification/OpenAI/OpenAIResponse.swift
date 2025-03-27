//
//  OpenAIResponse.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/25/25.
//

import Foundation

struct OpenAIResponse: Decodable, Equatable {
	
	let id: String
	let object: String
	let created: Int
	let model: String
	
	let choices: [OpenAIResponseChoice]
	
	static func == (lhs: OpenAIResponse, rhs: OpenAIResponse) -> Bool {
		return lhs.id == rhs.id
	}
	
	init(id: String, object: String, created: Int, model: String, choices: [OpenAIResponseChoice]) {
		self.id = id
		self.object = object
		self.created = created
		self.model = model
		self.choices = choices
	}
	
}

struct OpenAIResponseChoice: Decodable {
	let index: Int
	let message: OpenAIResponseMessage
	
	init(index: Int, message: OpenAIResponseMessage) {
		self.index = index
		self.message = message
	}
}

struct OpenAIResponseMessage: Decodable {
	let role: String
	let content: String
	
	init(role: String, content: String) {
		self.role = role
		self.content = content
	}
}
