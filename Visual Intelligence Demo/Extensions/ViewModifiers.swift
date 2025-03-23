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
}
