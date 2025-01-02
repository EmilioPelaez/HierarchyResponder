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
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let id: String
	let publisher: EventPublisher<E>
	@State var containers: Set<PublishersContainer> = []
	
	init(id: String, eventType: E.Type, handler: @escaping (E) -> Void) {
		self.id = id
		publisher = .init(id: id, publish: handler)
	}
	
	func body(content: Content) -> some View {
		content
			.publisherRegistrar(for: E.self, id: id, childContainers: $containers)
			.onAppearAndChange(of: registrars) { registrars in
				registerPublisher(registrars, containers: containers)
			}
			.onAppearAndChange(of: containers) { containers in
				registerPublisher(registrars, containers: containers)
			}
			.onDisappear(perform: unregisterPublisher)
	}
	
	func registerPublisher(_ registrars: RegistrarDictionary, containers: Set<PublishersContainer>) {
		guard let registrar = registrars[ObjectIdentifier(E.self)] else {
			let message = "Subscribed to event with no publisher: \(String(describing: E.self))"
			switch safetyLevel {
			case .strict: fatalError(message)
			case .relaxed: return print(message)
			case .disabled: return
			}
		}
		let container = PublishersContainer(id: id, publisher: publisher, containers: containers)
		registrar.register(container.id, container)
	}
	
	func unregisterPublisher() {
		registrars[ObjectIdentifier(E.self)]?.register(id, nil)
	}
}
