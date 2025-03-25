//
//  OpenAIPermissionView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/24/25.
//

import SwiftUI

struct OpenAIPermissionView: View {
	
	@Binding var isPresented: Bool
	
	var body: some View {
	   
		VStack(spacing: 25) {
			
			Spacer()
			
			Text("Share Data\nwith OpenAI?")
				.font(.title)
				.fontWeight(.medium)
				.multilineTextAlignment(.center)
			
			Text("Visual Intelligence shares captured images with OpenAI to provide additional analysis and understanding.")
				.font(.headline)
				.fontWeight(.medium)
				.multilineTextAlignment(.center)
			
			Text("Shared images may be stored by OpenAI to improve model accuracy in the future. By tapping continue you agree to sharing your data with OpenAI.")
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
					withAnimation(.easeOut) {
						isPresented = false
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
		OpenAIPermissionView(isPresented: .constant(true))
	}
}
