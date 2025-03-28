//
//  CameraControlsView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import SwiftUI

struct CameraControlsView: View {
	
	@Binding var viewModel: ContentViewModel
	
    var body: some View {
		HStack(alignment: .center, spacing: 40) {
			
			if (viewModel.classificationStatus == .initial && !viewModel.askingOpenAIQuestion) {
				SecondaryControlButton(symbol: "text.bubble", title: "Ask", action: {
					withAnimation {
						viewModel.askingOpenAIQuestion = true
					}
				})
			}
		
			Button(action: {
				
				if (viewModel.classificationStatus != .initial) {
					viewModel.close()
				} else if (viewModel.askingOpenAIQuestion) {
					withAnimation {
						viewModel.askingOpenAIQuestion = false
						viewModel.openAIQuestion = ""
					}
				} else {
					if !viewModel.capturingPhoto {
						viewModel.capturingPhoto = true
						Task {
							await viewModel.performVisionAnalysis()
						}
					}
				}
			}) {
				ZStack {
					
					if (viewModel.classificationStatus != .initial  || viewModel.askingOpenAIQuestion) {
						Image(systemName: "xmark")
							.font(.system(size: 30))
							.foregroundStyle(Color.white)
							.glow(color: .white, radius: 30)
							.background {
								Circle()
									.foregroundStyle(.ultraThinMaterial)
									.environment(\.colorScheme, .dark)
									.frame(width: 60, height: 60)
								
							}
					} else {
						Circle()
							.foregroundStyle(.white)
							.frame(width: 50, height: 50)
					}
					
					Circle()
						.stroke(Color.white, lineWidth: 2)
						.frame(width: 60, height: 60)
				}
			}
			
			if (viewModel.classificationStatus == .initial && !viewModel.askingOpenAIQuestion) {
				SecondaryControlButton(symbol: "photo", title: "Search", action: {
					if !viewModel.capturingPhoto {
						viewModel.capturingPhoto = true
						Task {
							await viewModel.captureAndRequestSimilarImagesFromGoogle()
						}
					}
				})
			}
		}
		.padding(.bottom, 20)
    }
}

#Preview {
	ZStack(alignment: .bottom) {
		Rectangle()
			.edgesIgnoringSafeArea(.all)
		
		CameraControlsView(viewModel: .constant(ContentViewModel()))
	}
	
	
}
