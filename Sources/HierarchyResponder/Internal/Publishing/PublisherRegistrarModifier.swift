//
//  PublisherRegistrarModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/28/24.
//

import SwiftUI

extension View {
	func publisherRegistrar<E: Event>(for event: E.Type,
																		id: String,
																		publisher: EventPublisher<E>?,
																		containers: Binding<Set<PublishersContainer>>) -> some View {
		modifier(PublisherRegistrarModifier(event: event,
																				id: id,
																				publisher: publisher,
																				containers: containers))
	}
}

struct PublisherRegistrarModifier<E: Event>: ViewModifier {
	@Environment(\.responderSafetyLevel) var safetyLevel
	@Environment(\.eventSubscriptionRegistrars) var registrars
	
	let id: String
	let publisher: EventPublisher<E>?
	@Binding var containers: Set<PublishersContainer>
	
	@State var registrar: EventSubscriptionRegistrar
	
	init(event: E.Type, id: String, publisher: EventPublisher<E>?, containers: Binding<Set<PublishersContainer>>) {
		self.id = id
		self.publisher = publisher
		self._containers = containers
		self._registrar = .init(initialValue: .init(id: id + "-empty") { _, _ in })
	}
	
	var updatedRegistrars: [ObjectIdentifier: EventSubscriptionRegistrar] {
		var registrars = registrars
		registrars[ObjectIdentifier(E.self)] = registrar
		return registrars
	}
	
	func body(content: Content) -> some View {
		content
			.onAppear(perform: createRegistrar)
			.onAppearAndChange(of: registrars) { registrars in
				registerPublisher(registrars, containers: containers)
			}
			.onAppearAndChange(of: containers) { containers in
				registerPublisher(registrars, containers: containers)
			}
			.environment(\.eventSubscriptionRegistrars, updatedRegistrars)
			.onDisappear(perform: unregisterPublisher)
	}
	
	func createRegistrar() {
		registrar = .init(id: id) { id, container in
			if let container {
				containers.update(with: container)
			} else if let container = containers.first(where: { $0.id == id }) {
				containers.remove(container)
			}
		}
	}
	
	func registerPublisher(_ registrars: RegistrarDictionary, containers: Set<PublishersContainer>) {
		guard let registrar = registrars[ObjectIdentifier(E.self)] else {
			if publisher == nil { return } //	We're on a publisher modifier
			let message = "Subscribed to event with no publisher: \(String(describing: E.self))"
			switch safetyLevel {
			case .strict: fatalError(message)
			case .relaxed: return print(message)
			case .disabled: return
			}
		}
		let publisher = self.publisher ?? EventPublisher(id: id) { _ in }
		let container = PublishersContainer(id: id, publisher: publisher, containers: containers)
		registrar.register(container.id, container)
	}
	
	func unregisterPublisher() {
		registrars[ObjectIdentifier(E.self)]?.register(id, nil)
	}
}
