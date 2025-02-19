//
//  ContentView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	
    @Environment(\.modelContext) private var modelContext
	
	@StateObject var camera = CameraModel()
	@StateObject var query = OpenAIQuery()
	@StateObject var classifier = Classifier()
	
	@State private var historySheetVisible: Bool = false
	@State private var askingQuestion: Bool = false
	@State private var question: String = ""
	@FocusState private var focused: Bool

    var body: some View {
		ZStack {
			
			CameraView(camera: camera)
				.edgesIgnoringSafeArea(.all)
			
//			Color.black
//				.edgesIgnoringSafeArea(.all)
			
			VStack {
				
				if (classifier.predicition != nil) {
					Text(classifier.predicition!)
						.padding()
						.background(.ultraThickMaterial)
						.clipShape(RoundedRectangle(cornerRadius: 10))
				}
				
				if (query.status == .waiting) {
					Text("Asking ChatGPT")
						.padding()
						.background(.ultraThickMaterial)
						.clipShape(RoundedRectangle(cornerRadius: 10))
				}
				
				if (query.response != nil) {
					VStack {
						
						ScrollView {
							Text(LocalizedStringKey(query.response?.choices.first?.message.content ?? ""))
						}
						
						Divider()
						
						HStack(alignment: .center) {
							
							Link(destination: URL(string: "https://www.openai.com")!) {
								Image("OpenAI")
									.resizable()
									.scaledToFit()
									.frame(width: 75)
							}
							
							Text("•  Check import info for mistakes ")
								.font(.callout)
								.foregroundStyle(Color(UIColor.systemGray))
							
							Spacer()
						}.padding(.top, 5)
					}
						.padding()
						.background(.ultraThickMaterial)
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.padding()
				}
				
				if (askingQuestion) {
					TextField("Ask a question", text: $question)
						.focused($focused)
						.foregroundStyle(Color.white)
						.padding()
						.background(.ultraThinMaterial)
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.padding()
						.onSubmit {
							camera.capture()
						}
				}
				
				Spacer()

				HStack(alignment: .center, spacing: 60) {
					
					Button(action: {
						withAnimation {
							askingQuestion.toggle()
							if askingQuestion {
								focused = true
							}
						}
					}) {
						Image(systemName: "text.bubble")
							.font(.system(size: 20))
							.foregroundStyle(Color.white)
							.padding(10)
							.background {
								Circle()
									.fill(.ultraThinMaterial)
							}
					}.buttonStyle(PlainButtonStyle())
					
					Button(action: {
						
						if (query.response != nil || query.status == .waiting || classifier.predicition != nil || classifier.status == .waiting) {
							classifier.reset()
							query.reset()
						} else {
							classifier.status = .waiting
							camera.capture()
						}
						
					}) {
						ZStack {
							
							if (query.response != nil || query.status == .waiting || classifier.predicition != nil || classifier.status == .waiting) {
								Image(systemName: "xmark")
									.font(.system(size: 25))
									.foregroundStyle(Color.white)
							} else {
								Circle()
									.fill(Color.white)
									.frame(width: 50, height: 50)
							}
							
							Circle()
								.stroke(Color.white, lineWidth: 2)
								.frame(width: 60, height: 60)
						}
					}
					.buttonStyle(PlainButtonStyle())
					
					Button(action: {
						withAnimation {
							historySheetVisible = true
						}
					}) {
						Image(systemName: "photo")
							.font(.system(size: 20))
							.foregroundStyle(Color.white)
							.padding(10)
							.background {
								Circle()
									.fill(.ultraThinMaterial)
							}
					}.buttonStyle(PlainButtonStyle())
				}
			}
		}.ignoresSafeArea(.keyboard, edges: .bottom)
		.overlay {
			if (query.status == .waiting || classifier.status == .waiting) {
				IntelligenceGlow()
			}
		}
		.sheet(isPresented: $historySheetVisible) {
			HistoryView()
		}
		.onChange(of: camera.capturedData) {
			Task {
				
				classifier.reset()
				query.reset()
				
				let image = UIImage(data: camera.capturedData!)!
				
				if (question == "") {
					classifier.classify(image)
				}
				
				if (classifier.predicition == nil) {
					await query.request(image: image, question: question)
				}
			}
		}
		.onChange(of: query.response) {
			if (query.response != nil) {
				let imageData = camera.capturedData ?? Data()
				let response = query.response?.choices.first?.message.content ?? ""
				let date = Date.now
				
				let item = Item(imageData: imageData, response: response, timestamp: date)
				modelContext.insert(item)
			}
		}
		.onChange(of: classifier.predicition) {
			if (classifier.predicition != nil) {
				let imageData = camera.capturedData ?? Data()
				let response = classifier.predicition!
				let date = Date.now
				
				let item = Item(imageData: imageData, response: response, timestamp: date)
				modelContext.insert(item)
			}
		}
    }
}

#Preview {
    ContentView()
}
