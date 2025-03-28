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
	
	func permissionButton() -> some View {
		self
			.buttonStyle(.plain)
			.fontWeight(.medium)
			.padding(.vertical, 6)
			.padding(.horizontal, 12)
			.background {
				Capsule()
					.foregroundStyle(.ultraThinMaterial)
					.environment(\.colorScheme, .light)
			}
	}
	
	func permissionOverlayBackground() -> some View {
		self
			.padding(40)
			.frame(maxWidth: .infinity)
			.edgesIgnoringSafeArea(.all)
			.background(.regularMaterial)
			.environment(\.colorScheme, .dark)
			.zIndex(1)
	}
}

struct RippleModifier: ViewModifier {
	var origin: CGPoint

	var elapsedTime: TimeInterval

	var duration: TimeInterval

	var amplitude: Double = 20
	var frequency: Double = 10
	var decay: Double = 10
	var speed: Double = 1000

	func body(content: Content) -> some View {
		let shader = ShaderLibrary.Ripple(
			.float2(origin),
			.float(elapsedTime),

			// Parameters
			.float(amplitude),
			.float(frequency),
			.float(decay),
			.float(speed)
		)

		let maxSampleOffset = maxSampleOffset
		let elapsedTime = elapsedTime
		let duration = duration

		content.visualEffect { view, _ in
			view.layerEffect(
				shader,
				maxSampleOffset: maxSampleOffset,
				isEnabled: 0 < elapsedTime && elapsedTime < duration
			)
		}
	}

	var maxSampleOffset: CGSize {
		CGSize(width: amplitude, height: amplitude)
	}
}

struct RippleEffect<T: Equatable>: ViewModifier {
	var origin: CGPoint

	var trigger: T

	init(at origin: CGPoint, trigger: T) {
		self.origin = origin
		self.trigger = trigger
	}

	func body(content: Content) -> some View {
		let origin = origin
		let duration = duration

		content.keyframeAnimator(
			initialValue: 0,
			trigger: trigger
		) { view, elapsedTime in
			view.modifier(RippleModifier(
				origin: origin,
				elapsedTime: elapsedTime,
				duration: duration
			))
		} keyframes: { _ in
			MoveKeyframe(0)
			LinearKeyframe(duration, duration: duration)
		}
	}

	var duration: TimeInterval { 3 }
}

#Preview {

	@Previewable @State var counter: Int = 0
	@Previewable @State var origin: CGPoint = .zero
	
	VStack {
			Spacer()

			Image("Arecaceae")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.clipShape(RoundedRectangle(cornerRadius: 24))
				.onTapGesture() { location in
					origin = location
					counter += 1
				}
				.modifier(RippleEffect(at: origin, trigger: counter))
				.shadow(radius: 3, y: 2)

			Spacer()
		}
		.padding()
	
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
	Image("Arecaceae")
		.resizable()
		.aspectRatio(contentMode: .fit)
		.modifier(IntelligenceOverlay(status: .constant(.waiting)))
		.clipShape(RoundedRectangle(cornerRadius: 24))
		.padding(25)
}
