//
//  CameraViewFinderView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import SwiftUI

struct CameraViewFinder: View {
	
	@Binding var viewModel: ContentViewModel
	
    var body: some View {
		ZStack {
			CameraFeedPreview(session: $viewModel.cameraSession, checkPermission: viewModel.checkPermissions)
				.edgesIgnoringSafeArea(.all)
		
			if (viewModel.classificationStatus != .initial && viewModel.capturedData != nil) {
				GeometryReader { geometry in
					
					let centerPoint = CGPoint(
						x: geometry.size.width / 2,
						y: geometry.size.height / 2
					)
					
					let image = UIImage(data: viewModel.capturedData!)!
					
					Image(uiImage: image)
						.resizable()
						.scaledToFill()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
						.edgesIgnoringSafeArea(.all)
						.modifier(RippleEffect(at: centerPoint, trigger: viewModel.classificationStatus == .waiting))
						.modifier(IntelligenceOverlay(status: $viewModel.classificationStatus))
						.sensoryFeedback(.impact(flexibility: .solid), trigger: viewModel.classificationStatus == .waiting)
						
				}.edgesIgnoringSafeArea(.all)
			}
		}
    }
}

#Preview {
	CameraViewFinder(viewModel: .constant(ContentViewModel()))
}
