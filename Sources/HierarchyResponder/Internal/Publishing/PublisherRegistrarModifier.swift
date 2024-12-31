//
//  PublisherRegistrarModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/28/24.
//

import SwiftUI

extension View {
	func publisherRegistrar<E: Event>(for event: E.Type, childContainers: Binding<Set<PublishersContainer>>) -> some View {
		modifier(PublisherRegistrarModifier(event: event, childContainers: childContainers))
	}
}

struct PublisherRegistrarModifier<E: Event>: ViewModifier {
	@Environment(\.eventSubscriptionRegistrars) var registrars
	
	@Binding var childContainers: Set<PublishersContainer>
	
	@State var registrar: EventSubscriptionRegistrar = .init { _, _ in }
	
	init(event: E.Type, childContainers: Binding<Set<PublishersContainer>>) {
		self._childContainers = childContainers
	}
	
	var updatedRegistrars: [ObjectIdentifier: [EventSubscriptionRegistrar]] {
		var registrars = registrars
		registrars[ObjectIdentifier(E.self)] = registrars[ObjectIdentifier(E.self), default: []] + [registrar]
		return registrars
	}
	
	func body(content: Content) -> some View {
		content
			.onAppear(perform: createRegistrar)
			.environment(\.eventSubscriptionRegistrars, updatedRegistrars)
	}
	
	func createRegistrar() {
		registrar = .init { id, container in
			if let container {
				childContainers.update(with: container)
			} else if let container = childContainers.first(where: { $0.id == id }) {
				childContainers.remove(container)
			}
		}
	}
}
