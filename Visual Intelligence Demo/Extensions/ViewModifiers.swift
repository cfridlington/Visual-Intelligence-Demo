//
//  ViewModifiers.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/19/25.
//

import SwiftUI

extension View {
	func glow(color: Color = .primary, radius: CGFloat = 20) -> some View {
		self
			.shadow(color: color, radius: radius / 3)
			.shadow(color: color, radius: radius / 3)
			.shadow(color: color, radius: radius / 3)
	}
	
	func card()  -> some View {
		self
			.padding(10)
			.background(.regularMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.buttonStyle(.plain)
			.padding()
	}
}
