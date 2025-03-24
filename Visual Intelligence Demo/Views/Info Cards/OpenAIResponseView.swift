//
//  OpenAIResponseView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/24/25.
//

import SwiftUI

struct OpenAIResponseView: View {
	
	var response: OpenAIResponse
	
    var body: some View {
		VStack {
			
			ScrollView {
				Text(LocalizedStringKey(response.choices.first?.message.content ?? ""))
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
			.frame(maxHeight: 400)
	}
}

#Preview {
//	OpenAIResponseView(response: OpenAIResponse)
}
