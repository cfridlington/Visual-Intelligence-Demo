//
//  OnDeviceKnowledgeView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/19/25.
//

import SwiftUI

struct OnDeviceKnowledgeView: View {
	
	@State private var expanded: Bool = false
	
	var classification: VisionClassificationKnowledge
	
    var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			
			VStack(alignment: .leading) {
				HStack {
					
					if (!expanded) {
						Image(systemName: classification.symbol)
					}
					
					Text(classification.displayName)
						.font(.headline)
				}
				
				if (expanded && classification.information != "") {
					Text(classification.information)
						.font(.subheadline)
				}
					
			}.padding(10)
			
			if (expanded && classification.wikipedia != nil) {
				Link(destination: classification.wikipedia!.link) {
					HStack {
						Image(classification.wikipedia!.title)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 100)
							.clipShape(RoundedRectangle(cornerRadius: 5))
						
						VStack(alignment: .leading, spacing: 3) {
							Text(classification.wikipedia!.title)
								.font(.subheadline)
								.fontWeight(.semibold)
							Text(classification.wikipedia!.category)
								.multilineTextAlignment(.leading)
								.font(.caption)
							
							Text("Wikipedia")
								.multilineTextAlignment(.leading)
								.font(.caption2)
								.foregroundStyle(.gray)
						}
						
						Spacer()
					}
				}
				.padding(10)
				.background(.thickMaterial)
				.clipShape(RoundedRectangle(cornerRadius: 10))
				.buttonStyle(.plain)
			}
			
			
			
			
		}
		.card()
		.onAppear {
			withAnimation(.bouncy.delay(1.5)) {
				expanded = true
			}
		}

    }
}

#Preview {
	
	let article = WikipediaArticle(title: "Retriever", category: "Dog Breed", link: URL(string: "https://en.wikipedia.org/wiki/Labrador_Retriever")!)
	let dog = VisionClassificationKnowledge(name: "retriever", description: "The Labrador Retriever or simply Labrador is a British breed of retriever gun dog. It was developed in the United Kingdom from St. John's water dogs imported from the colony of Newfoundland.", symbol: "dog.fill", wikipedia: article)
	
	GeometryReader { geometry in
	
		ZStack {
			
			Image("desk")
						.resizable()
						.aspectRatio(contentMode: .fill)
						.edgesIgnoringSafeArea(.all)
						.frame(maxWidth: geometry.size.width)
			
			OnDeviceKnowledgeView(classification: dog)
			
		}
		
	}
}
