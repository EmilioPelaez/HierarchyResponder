//
//  EventSubscriberModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

/**
 `EventSubscriberModifiers` read the registrar directory to find a registrar
 that matches the event type and registers the `handler` for the event
 publisher to publish an event. It also verifies that the event publisher
 exists.
 
 The subscriber modifier also replaces the registrar below in the chain, and
 any received publishers are stored and then concatenated when passed up the
 hierarchy.
 
 When the view disappears, the subscription is removed.
 */
struct EventSubscriberModifier<E: Event>: ViewModifier {
	@Environment(\.eventSubscriptionRegistrars) var registrars
	
	let id: String
	let publisher: EventPublisher<E>
	@State var containers: Set<PublishersContainer> = []
	
	init(id: String, eventType: E.Type, handler: @escaping (E) -> Void) {
		self.id = id
		publisher = .init(id: id, publish: handler)
	}
	
	func body(content: Content) -> some View {
		content
			.publisherRegistrar(for: E.self, id: id, publisher: publisher, containers: $containers)
			
	}
}
