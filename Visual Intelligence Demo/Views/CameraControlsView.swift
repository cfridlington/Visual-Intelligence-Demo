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
			
			Button(action: {
				
			}) {
				Image(systemName: "text.bubble")
					.font(.system(size: 20))
					.foregroundStyle(Color.white)
					.padding(10)
					.background {
						Circle()
							.fill(.ultraThinMaterial)
					}
			}.buttonStyle(PlainButtonStyle())
		
			Button(action: {
				
				if (viewModel.classificationStatus != .initial) {
					viewModel.close()
				} else {
					Task {
						await viewModel.performVisionAnalysis()
						await viewModel.performTextAnalysis()
					}
				}
			}) {
				ZStack {
					
					if (viewModel.classificationStatus != .initial) {
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
			
			Button(action: {
				
			}) {
				Image(systemName: "photo")
					.font(.system(size: 20))
					.foregroundStyle(Color.white)
					.padding(10)
					.background {
						Circle()
							.fill(.ultraThinMaterial)
					}
			}.buttonStyle(PlainButtonStyle())
		}
    }
}

#Preview {
	ZStack(alignment: .bottom) {
		Rectangle()
			.edgesIgnoringSafeArea(.all)
		
		CameraControlsView(viewModel: .constant(ContentViewModel()))
	}
	
	
}
