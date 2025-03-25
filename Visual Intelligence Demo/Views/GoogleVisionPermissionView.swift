//
//  GoogleVisionPermissionView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/24/25.
//

import SwiftUI

struct GoogleVisionPermissionView: View {
	
	@AppStorage("permissionGrantedGoogleVision") var permission: Bool = false
	
	@Binding var isPresented: Bool
	
	var continueRequest: () async -> Void
	
	var body: some View {
	   
		VStack(spacing: 25) {
			
			Spacer()
			
			Text("Share Data\nwith Google?")
				.font(.title)
				.fontWeight(.medium)
				.multilineTextAlignment(.center)
			
			Text("Visual Intelligence shares captured images with Google to find similar images on the web.")
				.font(.headline)
				.fontWeight(.medium)
				.multilineTextAlignment(.center)
			
			Text("Shared images may be stored by Google to improve search in the future. By tapping continue you agree to sharing your data with Google.")
				.font(.footnote)
				.fontWeight(.medium)
				.multilineTextAlignment(.center)
			
			Link("View Terms & Conditions", destination: URL(string: "https://openai.com/policies/terms-of-use/")!)
				.font(.footnote)
				.fontWeight(.semibold)
				.buttonStyle(.plain)
			
			Spacer()
			
			VStack(spacing: 20) {
				Button("Continue") {
					
					permission = true
					isPresented = false
					
					Task {
						await continueRequest()
					}
				}
				.permissionButton()
				
				
				Button("Cancel") {
					withAnimation(.easeOut) {
						isPresented = false
					}
				}
				.fontWeight(.medium)
				.buttonStyle(.plain)
			}
			
			Spacer()
			
		}
		.permissionOverlayBackground()
	}
}

#Preview {
	ZStack {
		Image("desk")
			.resizable()
			.edgesIgnoringSafeArea(.all)
		GoogleVisionPermissionView(isPresented: .constant(true), continueRequest: {})
	}
}
