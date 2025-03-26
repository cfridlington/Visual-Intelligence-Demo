//
//  SecondaryControlButton.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/26/25.
//

import SwiftUI

struct SecondaryControlButton: View {
	var symbol: String
	var title: String
	var action: () -> Void
	
	let spacing: CGFloat = 5
	let fontSize: CGFloat = 12
	
	var body: some View {
		
		Button(action: action) {
			VStack(spacing: spacing) {
				Image(systemName: symbol)
					.font(.system(size: 20))
					.foregroundStyle(Color.white)
					.padding(10)
					.background {
						Circle()
							.fill(.ultraThinMaterial)
					}
					.padding(0)
				
				Text(title)
					.font(.system(size: fontSize))
					.fontWeight(.semibold)
					.padding(0)
			}
		}.buttonStyle(PlainButtonStyle())
		.offset(y: (fontSize + spacing)/2)
		.environment(\.colorScheme, .dark)
		
	}
}

#Preview {
	ZStack(alignment: .bottom) {
		Rectangle()
			.edgesIgnoringSafeArea(.all)
		
		HStack {
			SecondaryControlButton(symbol: "text.bubble", title: "Ask", action: {})
			SecondaryControlButton(symbol: "photo", title: "Search", action: {})
		}
	}
}
