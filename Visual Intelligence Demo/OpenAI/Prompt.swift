//
//  Prompt.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/12/25.
//

import SwiftUI

class OpenAIPrompt {
	
	@AppStorage("prompt") var prompt: String = """
		Tell me some information about the subject of this image. Rather than describing the contents provide non-trivial information about the subject.
	"""
	
}
