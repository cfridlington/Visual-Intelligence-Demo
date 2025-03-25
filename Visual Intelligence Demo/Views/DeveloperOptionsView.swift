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
	
    var body: some View {
		NavigationStack {
			List {
				Section("Permissions") {
					
					Toggle("OpenAI", isOn: $openAIPermission)
						.fontWeight(.medium)
					Toggle("Google Vision", isOn: $googleVisionPermission)
						.fontWeight(.medium)
					
				}
				
				Section("API Keys") {
					VStack(alignment: .leading, spacing: 5) {
						Text("OpenAI")
							.fontWeight(.medium)
						
						Text("This API Key is used to authenticate request made to OpenAI's API. If you do not have a key, please contact Christopher or create a key in OpenAI's Developer Portal.")
							.font(.caption)
							.foregroundStyle(.secondary)
						
						TextField("", text: $openAIAPIKey)
							.fontDesign(.monospaced)
							.font(.caption)
							.fontWeight(.bold)
							.padding(5)
							.background {
								RoundedRectangle(cornerRadius: 5)
									.foregroundStyle(.ultraThickMaterial)
							}
					}
					VStack(alignment: .leading, spacing: 5) {
						Text("Google Cloud Vision")
							.fontWeight(.medium)
						
						Text("This API Key is used to authenticate request made to Google Cloud's Vision API. If you do not have a key, please contact Christopher or create a key in the Google Cloud Console.")
							.font(.caption)
							.foregroundStyle(.secondary)
						
						TextField("", text: $googleVisionAPIKey)
							.fontDesign(.monospaced)
							.font(.caption)
							.fontWeight(.bold)
							.padding(5)
							.background {
								RoundedRectangle(cornerRadius: 5)
									.foregroundStyle(.ultraThickMaterial)
							}
					}
				}
				
				Section("Credits") {
					VStack(alignment: .leading, spacing: 5) {
						Text("Christopher is an iOS Developer with a passion for all things design and technology. He believes great work happens at the intersection of technology and the liberal arts.\n\nHe received his BA in Computer Science & Architecture from Middlebury College.")
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
