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
	
	let publisher: EventPublisher<E>
	@State var registrar: EventSubscriptionRegistrar
	@State var container: PublishersContainer?
	
	var updatedRegistrars: [ObjectIdentifier: [EventSubscriptionRegistrar]] {
		var registrars = registrars
		registrars[ObjectIdentifier(E.self)] = registrars[ObjectIdentifier(E.self), default: []] + [registrar]
		return registrars
	}
	
	init(eventType: E.Type, handler: @escaping (E) -> Void) {
		publisher = .init(publish: handler)
		self.registrar = .init { _ in }
	}
	
	func body(content: Content) -> some View {
		content
			.onAppear(perform: createRegistrar)
			.onAppearAndChange(of: registrars) { registrars in
				registerPublisher(registrars, container: container)
			}
			.onAppearAndChange(of: container) { container in
				registerPublisher(registrars, container: container)
			}
			.onDisappear(perform: unregisterPublisher)
			.environment(\.eventSubscriptionRegistrars, updatedRegistrars)
	}
	
	func createRegistrar() {
		registrar = .init {
			container = $0
		}
	}
	
	func registerPublisher(_ registrars: RegistrarDictionary, container: PublishersContainer?) {
		guard let registrar = registrars[ObjectIdentifier(E.self)] else {
			let message = "Subscribed to event with no publisher: \(String(describing: E.self))"
			switch safetyLevel {
			case .strict: fatalError(message)
			case .relaxed: return print(message)
			case .disabled: return
			}
		}
		let publishers = container?.publishers ?? []
		let container = PublishersContainer(publishers: [publisher] + publishers)
		registrar.forEach { $0.register(container) }
	}
	
	func unregisterPublisher() {
		registrars[ObjectIdentifier(E.self)]?.forEach { $0.register(nil) }
	}
}
