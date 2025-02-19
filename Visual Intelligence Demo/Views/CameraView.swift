//
//  CameraView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/11/25.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
	
	@ObservedObject var camera: CameraModel
	
	func makeUIView(context: Context) -> some UIView {
		let view = UIView(frame: UIScreen.main.bounds)
		camera.checkPermissions()
		camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
		camera.preview.frame = view.frame
		camera.preview.videoGravity = .resizeAspectFill
		
		view.layer.addSublayer(camera.preview)
		
		camera.session.startRunning()
		
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
	
}

//#Preview {
//    CameraView()
//}
