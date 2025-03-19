//
//  WelcomeView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/19/25.
//

import SwiftUI

struct WelcomeView: View {
	
	@Binding var isPresented: Bool
	
    var body: some View {
       
		VStack(spacing: 25) {
			
			Spacer()
			
			Text("Welcome to\nVisual Intelligence")
				.font(.title)
				.fontWeight(.medium)
				.multilineTextAlignment(.center)
			
			Text("Learn more about the objects and places around you and get more information on what you see.")
				.font(.headline)
				.fontWeight(.medium)
				.multilineTextAlignment(.center)
			
			Text("The images iPhone uses to identify objects and places are not stored on device and are only used to process what's in view.")
				.font(.footnote)
				.fontWeight(.medium)
				.multilineTextAlignment(.center)
			
			Button("Continue") {
				withAnimation(.easeOut) {
					isPresented = false
				}
			}
			.buttonStyle(.plain)
			.fontWeight(.medium)
			.padding(.vertical, 6)
			.padding(.horizontal, 12)
			.background {
				Capsule()
					.foregroundStyle(.ultraThinMaterial)
					.environment(\.colorScheme, .light)
			}
			
			Spacer()
			
		}
			.padding(40)
			.frame(maxWidth: .infinity)
			.edgesIgnoringSafeArea(.all)
			.background(.regularMaterial)
			.zIndex(1) //for animation in ZStack
    }
}

#Preview {
	ZStack {
		Image("desk")
			.resizable()
			.edgesIgnoringSafeArea(.all)
		WelcomeView(isPresented: .constant(true))
	}
}
