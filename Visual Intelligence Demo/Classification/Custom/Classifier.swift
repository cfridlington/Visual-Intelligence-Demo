//
//  Classifier.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/12/25.
//

import Foundation
import UIKit
import CoreML

//class Classifier: ObservableObject {
//	
//	@Published var predicition: String? = nil
//	@Published var status: ClassifierStatus = .completed
//	
//	var confidenceThreshold: Double = 0.8
//	
//	public func classify(_ image: UIImage) {
//		
//		status = .waiting
//		
//		guard let resizedImage = image.resizeImageTo(size: CGSize(width: 360, height: 360)) else { return }
//		guard let buffer = resizedImage.convertToBuffer() else { return }
//		
//		do {
//			let model = try VisualIntelligenceKnowledge()
//			let output = try model.prediction(image: buffer)
//			
//			let sorted = output.targetProbability.sorted { $0.value > $1.value }
//			
//			if (sorted.first?.value ?? 0 > confidenceThreshold) {
//				predicition = sorted.first!.key
//			}
//			
//			status = .completed
//			
//		} catch {
//			print("Error Prediciting: \(error.localizedDescription)")
//		}
//		
//	}
//	
//	public func reset () {
//		predicition = nil
//	}
//	
//}
