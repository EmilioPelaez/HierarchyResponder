//
//  EventPublisherModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

struct EventPublisherModifier<E: Event>: ViewModifier {
	@Environment(\.publishingDestinations) var publishingDestinations
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let eventType: E.Type
	let destination: PublishingDestination
	let register: (EventPublisher<E>) -> Void
	
	func body(content: Content) -> some View {
		content
			.onPreferenceChange(EventPublisherKey<E>.self, perform: register)
			.transformEnvironment(\.publishingDestinations) { destinations in
				destinations[ObjectIdentifier(eventType)] = destination
			}
			.onAppear(perform: verifyPublisher)
			.onChange(of: publishingDestinations) { _ in verifyPublisher() }
	}
	
	func verifyPublisher() {
		let destination = publishingDestinations[ObjectIdentifier(eventType)]
		if destination == nil || destination == self.destination { return }
		switch safetyLevel {
		case .strict, .relaxed: print("Registrating duplicate publisher for event \(String(describing: eventType)) using a different destination. This may lead to unexpected behavior.")
		case .disabled: break
		}
	}
}
