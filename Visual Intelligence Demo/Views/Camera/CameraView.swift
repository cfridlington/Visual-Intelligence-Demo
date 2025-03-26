//
//  CameraView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/11/25.
//

import SwiftUI
import AVFoundation

struct CameraFeedPreview: UIViewRepresentable {
	
	@Binding var session: AVCaptureSession
	var checkPermission: () -> Void
	
	func makeUIView(context: Context) -> some UIView {
		let view = UIView(frame: UIScreen.main.bounds)
		
		checkPermission()
		
		let preview = AVCaptureVideoPreviewLayer(session: session)
		preview.frame = view.frame
		preview.videoGravity = .resizeAspectFill
		
		view.layer.addSublayer(preview)
		
		session.startRunning()
		
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
	
}
