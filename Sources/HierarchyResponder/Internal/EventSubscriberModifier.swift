//
//  EventSubscriberModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

struct EventSubscriberModifier<E: Event>: ViewModifier {
	@Environment(\.publishingDestinations) var publishingDestinations
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let eventType: E.Type
	let handler: (E) -> Void
	
	var destination: PublishingDestination {
		publishingDestinations[ObjectIdentifier(eventType)] ?? .default
	}
	
	func body(content: Content) -> some View {
		content
			.preference(key: EventPublisherKey<E>.self,
									value: EventPublisher<E>(destination: destination, publish: handler))
			.onAppear(perform: verifyPublisher)
			.onChange(of: publishingDestinations) { _ in verifyPublisher() }
	}
	
	func verifyPublisher() {
		if publishingDestinations[ObjectIdentifier(eventType)] != nil { return }
		switch safetyLevel {
		case .strict: fatalError("Subscribed to event with no publisher: \(String(describing: eventType))")
		case .relaxed: print("Subscribed to event with no publisher: \(String(describing: eventType))")
		case .disabled: break
		}
	}
}
