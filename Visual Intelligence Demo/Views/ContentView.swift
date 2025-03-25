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
	
	@State private var viewModel = ViewModel()
	
	@StateObject var camera = CameraModel()
	@StateObject var query = OpenAIQuery()
	@StateObject var classifier = Classifier()
	
	@FocusState private var focused: Bool

    var body: some View {
		
		ZStack {
			CameraView(session: $viewModel.cameraSession, checkPermission: viewModel.checkPermissions)
				.edgesIgnoringSafeArea(.all)
			
			if (viewModel.presentingWelcome) {
				WelcomeView(isPresented: $viewModel.presentingWelcome)
					.animation(.easeOut, value: viewModel.presentingWelcome)
			}
			
			VStack(spacing: 20) {
				
				HStack {
					Spacer()
					
					Menu(content: {
						Button("History", systemImage: "scroll") {
							viewModel.presentingHistory = true
						}
						Button("Developer Options", systemImage: "wrench.and.screwdriver") {
							viewModel.presentingDeveloperOptions = true
						}
					}, label: {
						Image(systemName: "ellipsis")
							.padding(10)
							.background {
								Circle()
									.foregroundStyle(.ultraThinMaterial)
							}
							
					}).buttonStyle(.plain)
					.environment(\.colorScheme, .dark)
				}.padding(.horizontal, 20)
				
				if (viewModel.onDeviceClassification != nil) {
					OnDeviceKnowledgeView(classification: viewModel.onDeviceClassification!)
				}
				
				if (viewModel.presentingEventView) {
					CalendarEventView(presented: $viewModel.presentingEventView, title: viewModel.eventTitle, date: viewModel.eventDate)
				}
				
				if (viewModel.presentingTextToSpeechView) {
					TextToSpeechView(text: viewModel.allRecognizedText ?? "", playPause: viewModel.playPauseSpokenText)
				}
				
				if (viewModel.openAIResponse != nil) {
					OpenAIResponseView(response: viewModel.openAIResponse!)
				}
				
				if (viewModel.presentingGoogleSimilarImages) {
					GoogleSimilarImagesView(results: viewModel.googleSimilarImagesResponse)
				}
				
				Spacer()
				
				if (
					!viewModel.presentingGoogleSimilarImages &&
					!viewModel.presentingEventView &&
					!viewModel.presentingTextToSpeechView
				) {
					HStack(spacing: 10) {
						
						if (viewModel.presentingExternalClassificationOptions) {
							ActionButton(symbol: "text.bubble", title: "Ask", action: {
								Task {
									await viewModel.sendQueryToOpenAI()
								}
							})
							
							ActionButton(symbol: "photo", title: "Search", action: {
								Task {
									await viewModel.requestSimilarImagesFromGoogle()
								}
							})
						}
						
						if (viewModel.eventDate != nil) {
							ActionButton(symbol: "calendar", title: "Add to Calendar", action: {
								withAnimation {
									viewModel.presentingEventView = true
								}
							})
						}
						
						if (viewModel.allRecognizedText != nil) {
							ActionButton(symbol: "speaker.wave.3.fill", title: "Read Text", action: {
								viewModel.speakRecognizedText()
							})
						}
					}
				}
				
				Button(action: {
					
					if (viewModel.classificationStatus == .waiting || viewModel.onDeviceClassification != nil) {
						viewModel.close()
					} else {
						Task {
//							await viewModel.performLocalClassification()
							await viewModel.performVisionAnalysis()
							await viewModel.performTextAnalysis()
						}
					}
				}) {
					ZStack {
						
						if (viewModel.classificationStatus == .waiting || viewModel.onDeviceClassification != nil) {
							Image(systemName: "xmark")
								.font(.system(size: 30))
								.foregroundStyle(Color.white)
								.glow(color: .white, radius: 30)
								.background {
									Circle()
										.foregroundStyle(.ultraThinMaterial)
										.environment(\.colorScheme, .dark)
										.frame(width: 60, height: 60)
										
								}
						} else {
							Circle()
								.foregroundStyle(.white)
								.frame(width: 50, height: 50)
						}
						
						Circle()
							.stroke(Color.white, lineWidth: 2)
							.frame(width: 60, height: 60)
					}
				}
			}
		}
		.overlay {
			if (viewModel.openAIQueryStatus == .waiting) {
				IntelligenceGlow()
			}
		}
		.sheet(isPresented: $viewModel.presentingHistory) {
			HistoryView()
		}
		.sheet(isPresented: $viewModel.presentingDeveloperOptions) {
			Text("Developer Options Coming Soon")
		}
		
		
//		ZStack {
//			
//			CameraView(camera: camera)
//				.edgesIgnoringSafeArea(.all)
//			
//			WelcomeView(presented: $viewModel.presentingWelcome)
//				.edgesIgnoringSafeArea(.all)
//			
////			Color.black
////				.edgesIgnoringSafeArea(.all)
//			
//			VStack {
//				
//				if (classifier.predicition != nil) {
//					Text(classifier.predicition!)
//						.padding()
//						.background(.ultraThickMaterial)
//						.clipShape(RoundedRectangle(cornerRadius: 10))
//				}
//				
//				if (query.status == .waiting) {
//					Text("Asking ChatGPT")
//						.padding()
//						.background(.ultraThickMaterial)
//						.clipShape(RoundedRectangle(cornerRadius: 10))
//				}
//				
//				if (query.response != nil) {
//					VStack {
//						
//						ScrollView {
//							Text(LocalizedStringKey(query.response?.choices.first?.message.content ?? ""))
//						}
//						
//						Divider()
//						
//						HStack(alignment: .center) {
//							
//							Link(destination: URL(string: "https://www.openai.com")!) {
//								Image("OpenAI")
//									.resizable()
//									.scaledToFit()
//									.frame(width: 75)
//							}
//							
//							Text("•  Check import info for mistakes ")
//								.font(.callout)
//								.foregroundStyle(Color(UIColor.systemGray))
//							
//							Spacer()
//						}.padding(.top, 5)
//					}
//						.padding()
//						.background(.ultraThickMaterial)
//						.clipShape(RoundedRectangle(cornerRadius: 10))
//						.padding()
//				}
//				
//				if (viewModel.askingQuestion) {
//					TextField("Ask a question", text: $viewModel.question)
//						.focused($focused)
//						.foregroundStyle(Color.white)
//						.padding()
//						.background(.ultraThinMaterial)
//						.clipShape(RoundedRectangle(cornerRadius: 10))
//						.padding()
//						.onSubmit {
//							camera.capture()
//						}
//				}
//				
//				Spacer()
//
//				HStack(alignment: .center, spacing: 60) {
//					
//					Button(action: {
//						withAnimation {
//							viewModel.askingQuestion.toggle()
//							if viewModel.askingQuestion {
//								focused = true
//							}
//						}
//					}) {
//						Image(systemName: "text.bubble")
//							.font(.system(size: 20))
//							.foregroundStyle(Color.white)
//							.padding(10)
//							.background {
//								Circle()
//									.fill(.ultraThinMaterial)
//							}
//					}.buttonStyle(PlainButtonStyle())
//					
//					Button(action: {
//						
//						if (query.response != nil || query.status == .waiting || classifier.predicition != nil || classifier.status == .waiting) {
//							classifier.reset()
//							query.reset()
//						} else {
//							classifier.status = .waiting
//							camera.capture()
//						}
//						
//					}) {
//						ZStack {
//							
//							if (query.response != nil || query.status == .waiting || classifier.predicition != nil || classifier.status == .waiting) {
//								Image(systemName: "xmark")
//									.font(.system(size: 25))
//									.foregroundStyle(Color.white)
//							} else {
//								Circle()
//									.fill(Color.white)
//									.frame(width: 50, height: 50)
//							}
//							
//							Circle()
//								.stroke(Color.white, lineWidth: 2)
//								.frame(width: 60, height: 60)
//						}
//					}
//					.buttonStyle(PlainButtonStyle())
//					
//					Button(action: {
//						withAnimation {
//							viewModel.presentingHistory = true
//						}
//					}) {
//						Image(systemName: "photo")
//							.font(.system(size: 20))
//							.foregroundStyle(Color.white)
//							.padding(10)
//							.background {
//								Circle()
//									.fill(.ultraThinMaterial)
//							}
//					}.buttonStyle(PlainButtonStyle())
//				}
//			}
//		}
//		.ignoresSafeArea(.keyboard, edges: .bottom)
//		.overlay {
//			if (query.status == .waiting || classifier.status == .waiting) {
//				IntelligenceGlow()
//			}
//		}
//		.sheet(isPresented: $viewModel.presentingHistory) {
//			HistoryView()
//		}
//		.onChange(of: camera.capturedData) {
//			Task {
//				
//				classifier.reset()
//				query.reset()
//				
//				let image = UIImage(data: camera.capturedData!)!
//				
//				if (viewModel.question == "") {
//					classifier.classify(image)
//				}
//				
//				if (classifier.predicition == nil) {
//					await query.request(image: image, question: viewModel.question)
//				}
//			}
//		}
//		.onChange(of: query.response) {
//			if (query.response != nil) {
//				let imageData = camera.capturedData ?? Data()
//				let response = query.response?.choices.first?.message.content ?? ""
//				let date = Date.now
//				
//				let item = Item(imageData: imageData, response: response, timestamp: date)
//				modelContext.insert(item)
//			}
//		}
//		.onChange(of: classifier.predicition) {
//			if (classifier.predicition != nil) {
//				let imageData = camera.capturedData ?? Data()
//				let response = classifier.predicition!
//				let date = Date.now
//				
//				let item = Item(imageData: imageData, response: response, timestamp: date)
//				modelContext.insert(item)
//			}
//		}
    }
}

#Preview {
    ContentView()
}
