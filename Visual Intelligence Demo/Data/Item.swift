//
//  Item.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/11/25.
//

import SwiftUI
import SwiftData

@Model
final class Item {
	
	var imageData: Data
	var response: String
    var timestamp: Date
    
	init(imageData: Data, response: String, timestamp: Date) {
		self.imageData = imageData
		self.response = response
		self.timestamp = timestamp
	}
}
