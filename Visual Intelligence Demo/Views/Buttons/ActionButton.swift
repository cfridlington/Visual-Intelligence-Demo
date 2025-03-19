//
//  ActionButton.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/19/25.
//

import SwiftUI

struct ActionButton: View {
	
	var symbol: String
	var title: String
	var action: () -> Void
	
    var body: some View {
		Button(action: action) {
			HStack(spacing: 5) {
				Image(systemName: symbol)
				Text(title)
			}
		}
			.font(.footnote)
			.fontWeight(.semibold)
			.buttonStyle(.plain)
			.padding(.vertical, 8)
			.padding(.leading, 9)
			.padding(.trailing, 10)
			.background {
				Capsule()
					.foregroundStyle(.ultraThinMaterial)
					.environment(\.colorScheme, .dark)
			}
		
		
		
    }
}

#Preview {
	ActionButton(symbol: "wrench.and.screwdriver", title: "Test", action: {})
}
