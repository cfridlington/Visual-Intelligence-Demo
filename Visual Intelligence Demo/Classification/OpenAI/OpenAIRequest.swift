//
//  OpenAIRequest.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/12/25.
//

import UIKit

class OpenAIRequest: Encodable {
	var model: String = "gpt-4o-mini"
	var messages: [OpenAIRequestMessage]
	
	init(model: String, messages: [OpenAIRequestMessage]) {
		self.model = model
		self.messages = messages
	}
}

class OpenAIRequestMessage: Encodable {
	var role: String
	var content: [OpenAIRequestMessageContent]
	
	init(role: String = "user", content: [OpenAIRequestMessageContent]) {
		self.role = role
		self.content = content
	}
}

class OpenAIRequestMessageContent: Encodable {
	var type: String
	
	init(type: String) {
		self.type = type
	}
}

final class OpenAIRequestMessageContentText: OpenAIRequestMessageContent {
	var text: String
	
	init (text: String) {
		self.text = text
		super.init(type: "text")
	}
	
	enum OpenAIRequestMessageContentTextCodingKeys: String, CodingKey {
		case text
	}
	
	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: OpenAIRequestMessageContentTextCodingKeys.self)
		try container.encode(text, forKey: .text)
		try super.encode(to: encoder)
	}
}

final class OpenAIRequestMessageContentImage: OpenAIRequestMessageContent {

	var image_url: OpenAIRequestMessageContentImageURL
	
	init (image: UIImage) {
		let base64Image = image.jpegData(compressionQuality: 0.25)?.base64EncodedString()
		let url = OpenAIRequestMessageContentImageURL(base64Image: base64Image)
		
		self.image_url = url
		super.init(type: "image_url")
	}
	
	enum OpenAIRequestMessageContentImageCodingKeys: String, CodingKey {
		case image_url
	}
	
	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: OpenAIRequestMessageContentImageCodingKeys.self)
		try container.encode(image_url, forKey: .image_url)
		try super.encode(to: encoder)
	}
}

class OpenAIRequestMessageContentImageURL: Codable {
	var url: String
	
	init(base64Image: String?) {
		self.url = "data:image/jpeg;base64,\(base64Image!)"
	}
}
