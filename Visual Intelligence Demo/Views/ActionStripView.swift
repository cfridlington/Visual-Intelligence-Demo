//
//  ActionStripView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import SwiftUI

struct ActionStripView: View {
	
	@Binding var viewModel: ContentViewModel
	
    var body: some View {
		HStack(spacing: 10) {
			
			if (viewModel.presentingExternalClassificationOptions) {
				ActionButton(symbol: "text.bubble", title: "Ask", action: {
					Task {
						await viewModel.sendQueryToOpenAI()
					}
				})
				
				ActionButton(symbol: "photo", title: "Search", action: {
					Task {
						await viewModel.requestSimilarImagesFromGoogle()
					}
				})
			}
			
			if (viewModel.eventDate != nil) {
				ActionButton(symbol: "calendar", title: "Add to Calendar", action: {
					withAnimation {
						viewModel.presentingEventView = true
					}
				})
			}
			
			if (viewModel.allRecognizedText != nil) {
				ActionButton(symbol: "speaker.wave.3.fill", title: "Read Text", action: {
					viewModel.speakRecognizedText()
				})
			}
		}
    }
}

#Preview {
	
	@Previewable @State var contentViewModel = ContentViewModel()

	VStack {
		
		Spacer()
		
		ActionStripView(viewModel: .constant(contentViewModel))
		
		Spacer()
		
		Divider()
			.padding(.bottom, 10)
		
		HStack(spacing: 20) {
			Button("External") {
				withAnimation {
					contentViewModel.presentingExternalClassificationOptions.toggle()
				}
			}
			Button("Date") {
				withAnimation {
					if (contentViewModel.eventDate == nil) {
						contentViewModel.eventDate = Date()
					} else {
						contentViewModel.eventDate = nil
					}
				}
			}
			Button("Speech") {
				withAnimation {
					if (contentViewModel.allRecognizedText == nil) {
						contentViewModel.allRecognizedText = "Hello World"
					} else {
						contentViewModel.allRecognizedText = nil
					}
				}
			}
		}
	}
}
