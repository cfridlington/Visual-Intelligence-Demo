//
//  GoogleSimilarImagesView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/24/25.
//

import SwiftUI

struct GoogleSimilarImagesView: View {
	
	let results: GoogleVisionResponse?
	
    var body: some View {
		VStack {
			
			if (results != nil) {
				ScrollView {
					HStack(alignment: .top, spacing: 20) {
						VStack(spacing: 20) {
							if (results!.responses.first!.webDetection.pagesWithMatchingImages != nil) {
								ForEach(Array(results!.responses.first!.webDetection.pagesWithMatchingImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 1 {
										GoogleSimilarImageResultView(title: result.pageTitle, pageURL: result.url, imageURL: result.partialMatchingImages.first!.url)
									}
									
								}
							} else if (results!.responses.first!.webDetection.partialMatchingImages != nil) {
								ForEach(Array(results!.responses.first!.webDetection.partialMatchingImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 1 {
										GoogleSimilarImageResultView(imageURL: result.url)
									}
								}
							} else if (results!.responses.first!.webDetection.visuallySimilarImages != nil) {
								ForEach(Array(results!.responses.first!.webDetection.visuallySimilarImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 1 {
										GoogleSimilarImageResultView(imageURL: result.url)
									}
								}
							}
						}
						VStack(spacing: 20) {
							if (results!.responses.first!.webDetection.pagesWithMatchingImages != nil) {
								ForEach(Array(results!.responses.first!.webDetection.pagesWithMatchingImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 0 {
										GoogleSimilarImageResultView(title: result.pageTitle, pageURL: result.url, imageURL: result.partialMatchingImages.first!.url)
									}
									
								}
							} else if (results!.responses.first!.webDetection.partialMatchingImages != nil) {
								ForEach(Array(results!.responses.first!.webDetection.partialMatchingImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 0 {
										GoogleSimilarImageResultView(imageURL: result.url)
									}
								}
							} else if (results!.responses.first!.webDetection.visuallySimilarImages != nil) {
								ForEach(Array(results!.responses.first!.webDetection.visuallySimilarImages!.enumerated()), id: \.element.url) { index, result in
									if index % 2 == 0 {
										GoogleSimilarImageResultView(imageURL: result.url)
									}
								}
							}
						}
					}
				}
			} else {
				VStack(alignment: .center) {
					Spacer()
					Text("No Images Found")
					Spacer()
				}.frame(maxHeight: 150)
				
				
			}
			
			Divider()
			
			HStack(alignment: .center) {
				
				Link(destination: URL(string: "https://www.google.com")!) {
					Image("Google")
						.resizable()
						.scaledToFit()
						.frame(width: 60)
						.padding(.top, 2)
				}
				
				Text("•  Results Provided by Google")
					.font(.callout)
					.foregroundStyle(Color(UIColor.systemGray))
				
				Spacer()
			}.padding(.top, 5)
		}
			.padding()
			.background(.ultraThickMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.padding()
			.frame(maxHeight: 600)
	}
}

struct GoogleSimilarImageResultView: View {
	
	var title: String?
	var pageURL: URL?
	var imageURL: URL
	
	@State private var loaded: Bool = false
	
	var body: some View {
		Link(destination: pageURL ?? imageURL) {
			VStack(alignment: .leading) {
				AsyncImage(url: URL(string: imageURL.absoluteString)) { phase in
					if let image = phase.image {
						image
							.resizable()
							.aspectRatio(contentMode: .fit)
							.background(.ultraThickMaterial)
							.onAppear {
								loaded = true
							}
					} else if (phase.error != nil) {
						EmptyView()
					} else {
						Rectangle()
							.foregroundStyle(.ultraThickMaterial)
							.frame(maxWidth: .infinity, minHeight: 80)
					}
				}
				.clipShape(RoundedRectangle(cornerRadius: 5))
				.padding(.bottom, 5)
				
				if (title != nil && pageURL != nil && loaded) {
					Text(title!)
						.font(.footnote)
						.fontWeight(.medium)
						.padding(.horizontal, 5)
						.lineLimit(1)
					Text(verbatim: pageURL!.absoluteString)
						.font(.caption2)
						.padding(.horizontal, 5)
						.foregroundStyle(.secondary)
						.lineLimit(1)
				}
			}
		}.buttonStyle(.plain)
	}
}

//#Preview {
//
//GoogleSimilarImageResultView(title: "Golden Retriever", pageURL: URL(string: "https://heronscrossing.vet/articles/the-upsides-and-downsides-of-owning-a-golden-retriever/")!, imageURL: URL(string: "https://heronscrossing.vet/wp-content/uploads/Golden-Retriever.jpg")!)
//
//GoogleSimilarImageResultView(title: "Elephant - Wikipedia", pageURL: URL(string: "https://en.wikipedia.org/wiki/Elephant")!, imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/37/African_Bush_Elephant.jpg")!)
//
//GoogleSimilarImageResultView(title: "Reticulated Giraffe | Saint Louis Zoo", pageURL: URL(string: "https://stlzoo.org/animals/mammals/hoofed-mammals/reticulated-giraffe")!, imageURL: URL(string: "https://transforms.stlzoo.org/production/animals/reticulated-giraffe-01-01.jpg?w=1200&h=1200&auto=compress%2Cformat&fit=crop&dm=1658951271&s=539e4b5c7b1f8c0287834e192ecc61d0")!)
//
//GoogleSimilarImageResultView(title: "Cheetah", pageURL: URL(string: "https://kids.nationalgeographic.com/animals/mammals/facts/cheetah")!, imageURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4KdwnYZPrfBh2nMNctD9rORN_yCFv7iHNsplI0YZCX57EGlz1ED5l1BmaI5-YCnBnPThpF4zMvDQZUc70t-zIwQ")!)
//

//	GoogleSimilarImagesView(results: <#Binding<GoogleVisionResponse>#>)
//}
