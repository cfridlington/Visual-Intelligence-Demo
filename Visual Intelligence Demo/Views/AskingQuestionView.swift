//
//  AskingQuestionView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import SwiftUI

struct AskingQuestionView: View {
	
	@Binding var viewModel: ContentViewModel
	
	@FocusState private var textFieldFocused: Bool
	
    var body: some View {
		HStack(spacing: 10) {
			
			TextField("Ask a question", text: $viewModel.openAIQuestion)
				.padding(10)
				.background(.regularMaterial)
				.clipShape(RoundedRectangle(cornerRadius: 10))
				.focused($textFieldFocused)
				.onAppear {
					textFieldFocused = true
				}
				.onSubmit {
					withAnimation {
						viewModel.openAIQuestion = ""
						viewModel.askingOpenAIQuestion = false
					}
				}
			
			Button(action: {
				withAnimation {
					viewModel.askingOpenAIQuestion = false
					textFieldFocused = false
					if !viewModel.capturingPhoto {
						viewModel.capturingPhoto = true
						Task {
							await viewModel.captureAndSendQueryToOpenAI()
						}
					}
					
				}
			}) {
				Image(systemName: "arrow.up")
					.padding(12)
					.background(.regularMaterial)
					.clipShape(Circle())
			}.disabled(viewModel.openAIQuestion == "")
		
		}
			.padding(20)
			.onDisappear {
				textFieldFocused = false
			}
			.environment(\.colorScheme, .dark)
    }
}

#Preview {
	ZStack {
		Rectangle()
			.edgesIgnoringSafeArea(.all)
		
		AskingQuestionView(viewModel: .constant(ContentViewModel()))
	}
}
