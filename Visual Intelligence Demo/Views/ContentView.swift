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
					ActionStripView(viewModel: $viewModel)
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
    }
}

#Preview {
    ContentView()
}
