//
//  IntelligenceGlow.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/12/25.
//

import SwiftUI

struct IntelligenceGlow: View {
	
	@State var gradientAngle: Double = 0
	
    var body: some View {
		RoundedRectangle(cornerRadius: 65)
			.stroke(AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center, angle: .degrees(gradientAngle)), lineWidth: 20)
			.blur(radius: 10)
			.edgesIgnoringSafeArea(.all)
			.onAppear {
				withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
					self.gradientAngle = 360
				}
			}
    }
}

struct IntelligenceOverlay: ViewModifier {
	
	@Binding var status: ClassifierStatus
	
	@State private var clearX: Float = 0.5
	@State private var clearY: Float = 0.5
	@State private var greenX: Float = 0.5
	@State private var indigoY: Float = 0.5
	
	func body(content: Content) -> some View {
		content
			.overlay {
				GeometryReader { container in
					MeshGradient(
						width: 3,
						height: 3,
						points: [
							[0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
							[0.0, 0.5], [clearX, clearY], [1.0, indigoY],
							[0.0, 1.0], [greenX, 1.0], [1.0, 1.0]
						],
						colors: [
							.red, .pink, .purple,
							.orange, .clear, .indigo,
							.yellow, .green, .blue
						]
					).opacity(status == .waiting ? 0.6 : 0)
					.animation(.easeInOut(duration: 2), value: status)
				}
			}
			.onAppear {
				withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
					clearX = 0.25
					clearY = 0.25
					greenX = 0.75
					indigoY = 0.75
				}
			}
	}
	
}

#Preview {
    IntelligenceGlow()
}

#Preview {
	Image("Arecaceae")
		.resizable()
		.aspectRatio(contentMode: .fit)
		.modifier(IntelligenceOverlay(status: .constant(.waiting)))
		.clipShape(RoundedRectangle(cornerRadius: 24))
		.padding(25)
}
