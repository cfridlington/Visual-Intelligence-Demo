//
//  HistoryView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/12/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \PreviousResponse.timestamp, order: .reverse) private var previousResponses: [PreviousResponse]
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(previousResponses) { response in
					
					NavigationLink(destination: HistoryDetailView(response: response)) {
						HStack(spacing: 10) {
							
							Image(uiImage: ((UIImage(data: response.imageData)) ?? UIImage(systemName: "photo"))!)
								.resizable()
								.scaledToFit()
								.frame(width: 60)
								.clipShape(RoundedRectangle(cornerRadius: 5))
							
							VStack(alignment: .leading, spacing: 5) {
								
								if response.visionClassification != nil {
									Text(response.visionClassification?.displayName ?? "Classified with Vision")
								}
								
								if response.openAIReponse != nil {
									Text("Response from OpenAI")
								}
								
								if response.googleVisionResponse != nil {
									Text("Found Similar Images")
								}
							
								Text("\(response.timestamp.formatted(date: .long, time: .shortened))")
									.font(.caption)
									.foregroundStyle(Color(uiColor: UIColor.systemGray))
							}
						}
					}
				}.onDelete(perform: deleteItem)
			}
			.navigationTitle("History")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar(content: {
				ToolbarItem(placement: .topBarTrailing) {
					
					Button("Done") {
						dismiss()
					}
					
				}
			})
		}
    }
	
	func deleteItem (_ indexSet: IndexSet) {
		for index in indexSet {
			let response = previousResponses[index]
			modelContext.delete(response)
		}
	}
}

struct HistoryDetailView: View {
	
	var response: PreviousResponse
	
	var body: some View {
		List {
			
			Section("Captured Image") {
				VStack(alignment: .leading, spacing: 10) {
					Image(uiImage: (UIImage(data: response.imageData) ?? UIImage(systemName: "photo"))!)
						.resizable()
						.scaledToFit()
						.clipShape(RoundedRectangle(cornerRadius: 5))
						.padding(.top, 5)
					
					Text("\(response.timestamp.formatted(date: .long, time: .shortened))")
						.font(.caption)
						.foregroundStyle(Color(uiColor: UIColor.systemGray))
					
				}
			}
			
			if response.visionClassification != nil {
				Section("Classification") {
					VStack(alignment: .leading) {
						Text(response.visionClassification?.displayName ?? "")
							.font(.headline)
						Text(response.visionClassification?.information ?? "")
							.font(.subheadline)
					}
				}
				
				if response.visionClassification?.wikipedia != nil {
					Section("Wikipedia") {
						Link(destination: response.visionClassification!.wikipedia!.link) {
							HStack {
								Image(response.visionClassification!.wikipedia!.title)
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(width: 100)
									.clipShape(RoundedRectangle(cornerRadius: 5))
								
								VStack(alignment: .leading, spacing: 3) {
									Text(response.visionClassification!.wikipedia!.title)
										.font(.subheadline)
										.fontWeight(.semibold)
									Text(response.visionClassification!.wikipedia!.category)
										.multilineTextAlignment(.leading)
										.font(.caption)
									
									Text("Wikipedia")
										.multilineTextAlignment(.leading)
										.font(.caption2)
										.foregroundStyle(.gray)
								}
								
								Spacer()
							}
						}.padding(.vertical, 5)
					}
				}
			}
			
			if response.openAIReponse != nil {
				Section("Response from OpenAI") {
					VStack(alignment: .leading, spacing: 10) {
						Text(LocalizedStringKey(response.openAIReponse ?? ""))
					}
				}
			}
			
			if response.googleVisionResponse != nil {
				Section("Response from Google Vision") {
					
					HStack(alignment: .top, spacing: 20) {
						
						VStack(spacing: 20) {
							if (response.googleVisionResponse!.responses.first!.webDetection.pagesWithMatchingImages != nil) {
								ForEach(Array(response.googleVisionResponse!.responses.first!.webDetection.pagesWithMatchingImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 1 {
										GoogleSimilarImageResultView(title: result.pageTitle, pageURL: result.url, imageURL: result.partialMatchingImages.first!.url)
									}
									
								}
							} else  if (response.googleVisionResponse!.responses.first!.webDetection.partialMatchingImages != nil) {
								ForEach(Array(response.googleVisionResponse!.responses.first!.webDetection.partialMatchingImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 1 {
										GoogleSimilarImageResultView(imageURL: result.url)
									}
								}
							} else if (response.googleVisionResponse!.responses.first!.webDetection.visuallySimilarImages != nil) {
								ForEach(Array(response.googleVisionResponse!.responses.first!.webDetection.visuallySimilarImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 1 {
										GoogleSimilarImageResultView(imageURL: result.url)
									}
								}
							}
						}
						VStack(spacing: 20) {
							if (response.googleVisionResponse!.responses.first!.webDetection.pagesWithMatchingImages != nil) {
								ForEach(Array(response.googleVisionResponse!.responses.first!.webDetection.pagesWithMatchingImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 0 {
										GoogleSimilarImageResultView(title: result.pageTitle, pageURL: result.url, imageURL: result.partialMatchingImages.first!.url)
									}
									
								}
							} else if (response.googleVisionResponse!.responses.first!.webDetection.partialMatchingImages != nil) {
								ForEach(Array(response.googleVisionResponse!.responses.first!.webDetection.partialMatchingImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 0 {
										GoogleSimilarImageResultView(imageURL: result.url)
									}
								}
							} else if (response.googleVisionResponse!.responses.first!.webDetection.visuallySimilarImages != nil) {
								ForEach(Array(response.googleVisionResponse!.responses.first!.webDetection.visuallySimilarImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 0 {
										GoogleSimilarImageResultView(imageURL: result.url)
									}
								}
							}
						}
					}
				}
			}
			
		}.navigationTitle("Detail")
	}
}

#Preview {
	
	let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: PreviousResponse.self, configurations: configuration)
	
	let imageData = UIImage(named: "Retriever")!.jpegData(compressionQuality: 0.5)!
	let visionResponse = PreviousResponse(imageData: imageData, visionClassification: VisionClassificationKnowledge(name: "Retriever", description: "Details...", symbol: "paw.fill", wikipedia: WikipediaArticle(title: "Retriever", category: "Dog Breed", link: "https://en.wikipedia.org/wiki/Retriever")))
	let openAIResponse = PreviousResponse(imageData: imageData, openAIResponse: "Hello World")
	let googleVisionResponse = PreviousResponse(imageData: imageData, googleVisionResponse: GoogleVisionResponse(responses: [GoogleVisionResponseType(webDetection: GoogleVisionReponseWebDetection(partialMatchingImages: [GoogleVisionReponseImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Golden_Retriever_charge.jpg/500px-Golden_Retriever_charge.jpg")!), GoogleVisionReponseImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Golden_Retriever_charge.jpg/500px-Golden_Retriever_charge.jpg")!)]))]))
	
	container.mainContext.insert(visionResponse)
	container.mainContext.insert(openAIResponse)
	container.mainContext.insert(googleVisionResponse)
	
    return HistoryView()
		.modelContainer(container)
}
