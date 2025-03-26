//
//  CalendarEventView.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/23/25.
//

import SwiftUI
import EventKit

struct CalendarEventView: View {
	
	@Binding var presented: Bool
	
	@State private var showAlert: Bool = false
	@State private var alertTitle: String = ""
	@State private var alertMessage: String = ""
	
	var title: String?
	var date: Date?
	
	var formattedDate: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter.string(from: date ?? Date())
	}
	
	var formattedTime: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .short
		return formatter.string(from: date ?? Date())
	}
	
    var body: some View {
		VStack(alignment: .leading) {
			
			
			
			Text(formattedDate)
				.font(.headline)
				.padding(.horizontal, 10)
				.padding(.top, 5)
			
			HStack(spacing: 0) {
				
				RoundedRectangle(cornerRadius: 5)
					.frame(width: 5, height: 60)
					.padding()
					.foregroundStyle(.blue.opacity(0.75))
				
				VStack(alignment: .leading) {
					Text(title ?? "New Event")
						.font(.subheadline)
						.fontWeight(.medium)
					
					Text(formattedTime)
						.font(.subheadline)
				}

				Spacer()
				
			}
			.frame(maxWidth: .infinity)
			.background {
				RoundedRectangle(cornerRadius: 10)
					.foregroundStyle(.blue.opacity(0.1))
			}
			
			HStack {
				Button("Cancel") {
					withAnimation {
						presented = false
					}
				}
					.frame(maxWidth: .infinity)
					.padding(10)
					.background(.gray.opacity(0.35))
					.clipShape(RoundedRectangle(cornerRadius: 10))
					
				Button("Schedule") {
					withAnimation {
						requestCalendarAccess(title: title ?? "New Event", date: date ?? Date())
					}
				}
					.frame(maxWidth: .infinity)
					.foregroundStyle(.white)
					.padding(10)
					.background(.blue.opacity(0.75))
					.clipShape(RoundedRectangle(cornerRadius: 10))
			}
			
		}
		.card()
		.alert(isPresented: $showAlert) {
			Alert(title: Text(alertTitle), message: Text(alertMessage))
		}
		
    }
	
	func requestCalendarAccess(title: String, date: Date) {
		let eventStore = EKEventStore()
		
		eventStore.requestWriteOnlyAccessToEvents() { (granted, error) in
			if granted && error == nil {
				let calendarEvent = EKEvent(eventStore: eventStore)
				calendarEvent.title = title
				calendarEvent.startDate = date
				calendarEvent.endDate = date.addingTimeInterval(3600)
				calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
				
				do {
					try eventStore.save(calendarEvent, span: .thisEvent)
					withAnimation {
						presented = false
					}
				} catch {
						alertTitle = "Error"
						alertMessage = "There was an error adding the event to your calendar."
						showAlert = true
				}
			} else {
					alertTitle = "Error"
					alertMessage = "Access to the calendar was denied."
					showAlert = true
			}
		}
	}
	
}

#Preview {
	CalendarEventView(presented: .constant(true), title: "Hello World", date: Date())
}
