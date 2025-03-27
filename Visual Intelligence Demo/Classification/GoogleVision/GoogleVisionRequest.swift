//
//  GoogleVisionRequest.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/25/25.
//

import Foundation
import UIKit

//{
//  "requests": [
//	{
//	  "image": {
//		"content": "BASE64_ENCODED_IMAGE"
//	  },
//	  "features": [
//		{
//		  "maxResults": RESULTS_INT,
//		  "type": "WEB_DETECTION"
//		},
//	  ]
//	}
//  ]
//}


struct GoogleVisionRequest: Encodable {
	var requests: [GoogleVisionRequestMessageContent]
}

struct GoogleVisionRequestMessageContent: Encodable {
	var image: GoogleVisionRequestMessageImage
	var features: [GoogleVisionRequestMessageFeature]
}

struct GoogleVisionRequestMessageImage: Encodable {
	var content: String
	
	init (image: UIImage) {
		let base64Image = image.jpegData(compressionQuality: 1)!.base64EncodedString()
		self.content = base64Image
	}
	
}

struct GoogleVisionRequestMessageFeature: Encodable {
	var maxResults: Int
	var type: String = "WEB_DETECTION"
}
