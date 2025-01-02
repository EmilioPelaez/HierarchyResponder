//
//  PublisherRegistrarModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/28/24.
//

import SwiftUI

extension View {
	func publisherRegistrar<E: Event>(for event: E.Type, id: String, childContainers: Binding<Set<PublishersContainer>>) -> some View {
		modifier(PublisherRegistrarModifier(event: event, id: id, childContainers: childContainers))
	}
}

struct PublisherRegistrarModifier<E: Event>: ViewModifier {
	@Environment(\.eventSubscriptionRegistrars) var registrars
	
	let id: String
	@Binding var childContainers: Set<PublishersContainer>
	
	@State var registrar: EventSubscriptionRegistrar
	
	init(event: E.Type, id: String, childContainers: Binding<Set<PublishersContainer>>) {
		self.id = id
		self._childContainers = childContainers
		self._registrar = .init(initialValue: .init(id: id) { _, _ in })
	}
	
	var updatedRegistrars: [ObjectIdentifier: EventSubscriptionRegistrar] {
		var registrars = registrars
		registrars[ObjectIdentifier(E.self)] = registrar
		return registrars
	}
	
	func body(content: Content) -> some View {
		content
			.onAppear(perform: createRegistrar)
			.environment(\.eventSubscriptionRegistrars, updatedRegistrars)
	}
	
	func createRegistrar() {
		registrar = .init(id: id) { id, container in
			if let container {
				childContainers.update(with: container)
			} else if let container = childContainers.first(where: { $0.id == id }) {
				childContainers.remove(container)
			}
		}
	}
}
