//
//  ContentView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	
    @Environment(\.modelContext) private var modelContext
	
	@State private var viewModel = ContentViewModel()

    var body: some View {
		
		ZStack(alignment: .center) {
			
			CameraViewFinder(viewModel: $viewModel)
			
			if (viewModel.presentingWelcome) {
				WelcomeView(isPresented: $viewModel.presentingWelcome)
					.animation(.easeOut, value: viewModel.presentingWelcome)
			}
			
			if (viewModel.presentingOpenAIPermissionsView) {
				OpenAIPermissionView(isPresented: $viewModel.presentingOpenAIPermissionsView, continueRequest: viewModel.sendQueryToOpenAI)
			}
			
			if (viewModel.presentingGoogleVisionPermissionsView) {
				GoogleVisionPermissionView(isPresented: $viewModel.presentingGoogleVisionPermissionsView, continueRequest: viewModel.requestSimilarImagesFromGoogle)
			}
			
			VStack(spacing: 20) {
				
				HStack {
					Spacer()
					
					Menu(content: {
						Button("History", systemImage: "scroll") {
							viewModel.presentingHistory = true
						}
						Button("Developer Options", systemImage: "wrench.and.screwdriver") {
							viewModel.presentingDeveloperOptions = true
						}
					}, label: {
						Image(systemName: "ellipsis")
							.padding(10)
							.background {
								Circle()
									.foregroundStyle(.ultraThinMaterial)
							}
						
					}).buttonStyle(.plain)
						.environment(\.colorScheme, .dark)
				}.padding(.horizontal, 20)
				
				if (viewModel.onDeviceClassification != nil) {
					OnDeviceKnowledgeView(classification: viewModel.onDeviceClassification!)
				}
				
				if (viewModel.presentingEventView) {
					CalendarEventView(presented: $viewModel.presentingEventView, title: viewModel.eventTitle, date: viewModel.eventDate)
				}
				
				if (viewModel.presentingTextToSpeechView) {
					TextToSpeechView(text: viewModel.allRecognizedText ?? "", playPause: viewModel.playPauseSpokenText)
				}
				
				if (viewModel.openAIResponse != nil) {
					OpenAIResponseView(response: viewModel.openAIResponse!)
				}
				
				if (viewModel.presentingGoogleSimilarImages) {
					GoogleSimilarImagesView(results: viewModel.googleSimilarImagesResponse)
				}
				
				Spacer()
				
				if (
					!viewModel.presentingGoogleSimilarImages &&
					!viewModel.presentingEventView &&
					!viewModel.presentingTextToSpeechView
				) {
					ActionButtonStripView(viewModel: $viewModel)
				}
				
				CameraControlsView(viewModel: $viewModel)
				
			}
		}
		.sheet(isPresented: $viewModel.presentingHistory) {
			HistoryView()
		}
		.sheet(isPresented: $viewModel.presentingDeveloperOptions) {
			DeveloperOptionsView()
		}
		.alert("API Key Required for OpenAI", isPresented: $viewModel.openAIMissingAPIAlert) {
			
			Button("Add in Developer Options", role: .none) {
				withAnimation {
					viewModel.presentingDeveloperOptions = true
					viewModel.openAIMissingAPIAlert = false
				}
			}
			
			Link("Request a Demo API Key", destination: URL(string: "https://www.cfridlington.com/contact")!)
			
			Button("Cancel", role: .cancel) { }
		} message: {
			Text("An API Key is required to use OpenAI. This can be obtained in the OpenAI Developer Portal. Alternatively, you may request a demo API Key from Christopher Fridlington.")
		}
		.alert("API Key Required for Google Vision", isPresented: $viewModel.googleVisionMissingAPIAlert) {
			
			Button("Add in Developer Options", role: .none) {
				withAnimation {
					viewModel.presentingDeveloperOptions = true
					viewModel.googleVisionMissingAPIAlert = false
				}
			}
			
			Link("Request a Demo API Key", destination: URL(string: "https://www.cfridlington.com/contact")!)
			
			Button("Cancel", role: .cancel) { }
		} message: {
			Text("An API Key is required to use the Google Vision. This can be obtained in the Google Cloud Console. Alternatively, you may request a demo API Key from Christopher Fridlington.")
		}
		.alert("OpenAI API Error", isPresented: $viewModel.openAIAPIError) {
			Button("Dismiss", role: .cancel) { }
		} message: {
			Text("An error occured when attempting to communicate with the OpenAI API. Please confirm the entered API Key is correct.")
		}
		.alert("Google Vision API Error", isPresented: $viewModel.googleVisionAPIError) {
			Button("Dismiss", role: .cancel) { }
		} message: {
			Text("An error occured when attempting to communicate with the Google Vision API. Please confirm the entered API Key is correct.")
		}
    }
}

#Preview {
    ContentView()
}
