//
//  TextToSpeechView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/24/25.
//

import SwiftUI

struct TextToSpeechView: View {
	
	var text: String
	var playPause: () -> Void
	
	@State private var playing: Bool = true
	
    var body: some View {
		
		VStack(alignment: .leading) {
			
			HStack {
				Image(systemName: "speaker.wave.3.fill")
				Text("Reading Text")
			}.font(.headline)
			
			ScrollView {
				Text(text)
			}
			.frame(maxHeight: 200)
			
			HStack {
				Spacer()
				
				Button(action: {
					playPause()
					playing.toggle()
				}) {
					if playing {
						Image(systemName: "pause.fill")
					} else {
						Image(systemName: "play.fill")
					}
				}
				.padding(10)
				.background(.thickMaterial)
				.clipShape(Circle())
				
			}
			
		}.padding(10)
		.card()
    }
}

#Preview {
	TextToSpeechView(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", playPause: {})
}
