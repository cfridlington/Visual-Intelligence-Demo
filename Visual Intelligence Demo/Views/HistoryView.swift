//
//  HistoryView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 2/12/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
	
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(items) { item in
					
					NavigationLink(destination: HistoryDetailView(item: item)) {
						HStack(spacing: 10) {
							
							Image(uiImage: ((UIImage(data: item.imageData)) ?? UIImage(systemName: "photo"))!)
								.resizable()
								.scaledToFit()
								.frame(width: 60)
								.clipShape(RoundedRectangle(cornerRadius: 10))
							
							VStack(alignment: .leading, spacing: 5) {
								Text(item.response)
									.lineLimit(3)
								Text("\(item.timestamp.formatted(date: .long, time: .shortened))")
									.font(.caption)
									.foregroundStyle(Color(uiColor: UIColor.systemGray))
							}
						}
					}
				}.onDelete(perform: deleteItem)
				
//				Button(action: {
//					let item = Item(imageData: Data(), response: "Hello World", timestamp: Date.now)
//					modelContext.insert(item)
//				}) {
//					Text("Add Data")
//				}
			}
			.navigationTitle("History")
			.navigationBarTitleDisplayMode(.inline)
		}
    }
	
	func deleteItem (_ indexSet: IndexSet) {
		for index in indexSet {
			let item = items[index]
			modelContext.delete(item)
		}
	}
}

struct HistoryDetailView: View {
	
	var item: Item
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 10) {
				Image(uiImage: (UIImage(data: item.imageData) ?? UIImage(systemName: "photo"))!)
					.resizable()
					.scaledToFit()
					.clipShape(RoundedRectangle(cornerRadius: 10))
				
				Text(LocalizedStringKey(item.response))
				
				Text("\(item.timestamp.formatted(date: .long, time: .shortened))")
					.font(.caption)
					.foregroundStyle(Color(uiColor: UIColor.systemGray))
				
			}.padding()
		}.navigationTitle("Detail")
	}
}

#Preview {
    HistoryView()
		.modelContainer(for: Item.self, inMemory: true)
}
