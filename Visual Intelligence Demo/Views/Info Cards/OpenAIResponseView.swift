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
	
	let choices = [OpenAIResponseChoice(index: 1, message: OpenAIResponseMessage(role: "agent", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))]
	let response = OpenAIResponse(id: UUID().uuidString, object: "", created: 0, model: "gpt-4o-mini", choices: choices)
	
	OpenAIResponseView(response: response)
	
}
