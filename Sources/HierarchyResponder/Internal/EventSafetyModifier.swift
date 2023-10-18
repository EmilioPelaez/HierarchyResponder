//
//  Created by Emilio Peláez on 09/10/23.
//

import SwiftUI

struct EventSafetyModifier: ViewModifier {
	@Environment(\.requiresExplicitResponders) var requiresExplicitResponders
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	@Environment(\.handledEvents) var receivedEvents
	
	let events: [any Event.Type]
	let location: String
	
	@State var declaredEvents: [any Event.Type] = []
	var allDeclaredEvents: [any Event.Type] {
		events + declaredEvents
	}
	
	func body(content: Content) -> some View {
		content
			.receiveEvent { event in
				let found = (events + declaredEvents).contains { type(of: event) == $0 }
				if found { return .notHandled }
				switch safetyLevel {
				case .disabled: break
				case .relaxed: print("Received unregistered event \(String(describing: type(of: event))) at \(location)")
				case .strict: fatalError("Received unregistered event \(String(describing: type(of: event))) at \(location)")
				}
				return .notHandled
			}
			.onPreferenceChange(DeclaredEventsKey.self) { value in declaredEvents = value.events }
			.preference(key: DeclaredEventsKey.self, value: .init(events: allDeclaredEvents))
			.onAppear {
				guard requiresExplicitResponders else { return }
				let unregistered = events.filter { event in
					!receivedEvents.contains { $0 == event }
				}
				if unregistered.isEmpty { return }
				let eventsString = unregistered.map { String(describing: $0) }.joined(separator: ", ")
				switch safetyLevel {
				case .disabled: break
				case .relaxed: print("The following events don't have a registered handler: " + eventsString)
				case .strict: fatalError("The following events don't have a registered handler: " + eventsString)
				}
			}
	}
}
