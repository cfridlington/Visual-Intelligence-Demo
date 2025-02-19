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

#Preview {
    IntelligenceGlow()
}
