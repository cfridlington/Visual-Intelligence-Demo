//
//  DeveloperOptionsView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/25/25.
//

import SwiftUI

struct DeveloperOptionsView: View {
	
	@AppStorage("permissionGrantedOpenAI") var openAIPermission: Bool = false
	@AppStorage("permissionGrantedGoogleVision") var googleVisionPermission: Bool = false
	
	@AppStorage("openAIAPIKey") var openAIAPIKey: String = ""
	@AppStorage("googleVisionAPIKey") var googleVisionAPIKey: String = ""
	
	@AppStorage("openAIPrompt") var openAIPrompt: String = "Tell me some information about the subject of this image. Rather than describing the contents provide non-trivial information about the subject."
	
    var body: some View {
		NavigationStack {
			List {
				Section("Permissions") {
					
					Toggle("OpenAI", isOn: $openAIPermission)
					
					Toggle("Google Vision", isOn: $googleVisionPermission)
					
				}
				
				Section("API Keys") {
					VStack(alignment: .leading, spacing: 5) {
						Text("OpenAI")
						
						Text("This API Key is used to authenticate request made to OpenAI's API. If you do not have a key, please contact Christopher or create a key in OpenAI's Developer Portal.")
							.font(.caption)
							.foregroundStyle(.secondary)
						
						TextField("", text: $openAIAPIKey)
							.fontDesign(.monospaced)
							.font(.caption)
							.fontWeight(.medium)
							.padding(5)
							.background {
								RoundedRectangle(cornerRadius: 5)
									.foregroundStyle(.ultraThickMaterial)
							}
					}
					VStack(alignment: .leading, spacing: 5) {
						Text("Google Cloud Vision")
						
						Text("This API Key is used to authenticate request made to Google Cloud's Vision API. If you do not have a key, please contact Christopher or create a key in the Google Cloud Console.")
							.font(.caption)
							.foregroundStyle(.secondary)
						
						TextField("", text: $googleVisionAPIKey)
							.fontDesign(.monospaced)
							.font(.caption)
							.fontWeight(.medium)
							.padding(5)
							.background {
								RoundedRectangle(cornerRadius: 5)
									.foregroundStyle(.ultraThickMaterial)
							}
					}
				}
				
				Section("OpenAI Prompt") {
					VStack(alignment: .leading, spacing: 5) {
						Text("Customize Prompt")
						
						Text("Modify this prompt to tune the response provided from OpenAI.")
							.font(.caption)
							.foregroundStyle(.secondary)
						
						TextField("Prompt", text: $openAIPrompt, axis: .vertical)
							.fontDesign(.monospaced)
							.font(.caption)
							.fontWeight(.medium)
							.padding(5)
							.background {
								RoundedRectangle(cornerRadius: 5)
									.foregroundStyle(.ultraThickMaterial)
							}
					}
				}
				
				Section("Credits") {
					VStack(alignment: .leading, spacing: 5) {
						
						Text("Created by Christopher Fridlington")
						
						Text("Christopher is an iOS Developer with a passion for all things design and technology. He believes great work happens at the intersection of technology and the liberal arts. He received his BA in Computer Science & Architecture from Middlebury College.")
							.font(.caption)
							.foregroundStyle(.secondary)
						
						Link("Learn More", destination: URL(string: "https://www.cfridlington.com")!)
							.font(.caption)
					}
				}
			}.navigationTitle("Developer Options")
				.navigationBarTitleDisplayMode(.inline)
		}
    }
}

#Preview {
    DeveloperOptionsView()
}
