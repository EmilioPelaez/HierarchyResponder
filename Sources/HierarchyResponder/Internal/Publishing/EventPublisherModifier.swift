//
//  EventPublisherModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

typealias RegistrarDictionary = [ObjectIdentifier: EventSubscriptionRegistrar]

struct EventPublisherModifier<E: Event>: ViewModifier {
	@Environment(\.eventSubscriptionRegistrars) var registrars
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let destination: PublishingDestination
	let register: (EventPublisher<E>?) -> Void
	
	@State var registrar: EventSubscriptionRegistrar
	@State var container: PublishersContainer?
	
	var updatedRegistrars: [ObjectIdentifier: EventSubscriptionRegistrar] {
		var registrars = registrars
		registrars[ObjectIdentifier(E.self)] = registrar
		return registrars
	}
	
	init(destination: PublishingDestination, register: @escaping (EventPublisher<E>?) -> Void) {
		self.destination = destination
		self.register = register
		self.registrar = .init { _ in }
	}
	
	func body(content: Content) -> some View {
		content
			.onAppearAndChange(of: registrars, perform: verifyPublisher)
			.onAppear(perform: createRegistrar)
			.onChange(of: container) { container in
				updatePublisher(container: container, destination: destination)
			}
			.onChange(of: destination) { destination in
				updatePublisher(container: container, destination: destination)
			}
			.onDisappear { register(nil) }
			.environment(\.eventSubscriptionRegistrars, updatedRegistrars)
	}
	
	func createRegistrar() {
		registrar = .init { container = $0 }
	}
	
	func verifyPublisher(_ registrars: RegistrarDictionary) {
		if registrars[ObjectIdentifier(E.self)] == nil { return }
		switch safetyLevel {
		case .strict, .relaxed: print("Registrating duplicate publisher for event \(String(describing: E.self)). This may lead to unexpected behavior.")
		case .disabled: break
		}
	}
	
	func updatePublisher(container: PublishersContainer?, destination: PublishingDestination) {
		let publishers = container?.publishers.compactMap { $0 as? EventPublisher<E> } ?? []
		let publisher: EventPublisher<E>?
		switch destination {
		case .firstSubscriber: publisher = publishers.first
		case .allSubscribers: publisher = .init { event in
			publishers.forEach { $0.publish(event) }
		}
		case .lastSubscriber: publisher = publishers.last
		}
		register(publisher)
	}
}
