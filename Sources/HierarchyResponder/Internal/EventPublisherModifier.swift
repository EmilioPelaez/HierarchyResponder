//
//  EventPublisherModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

struct EventPublisherModifier<E: Event>: ViewModifier {
	@Environment(\.eventSubscriptionRegistrars) var registrars
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let registrar: EventSubscriptionRegistrar
	
	init(destination: PublishingDestination, register: @escaping (EventPublisher<E>) -> Void) {
		self.registrar = .init(destination: destination) { registrar in
			guard let registrar = registrar as? EventPublisher<E> else {
				fatalError("Registrar type mismatch")
			}
			register(registrar)
		}
	}
	
	func body(content: Content) -> some View {
		content
			.transformEnvironment(\.eventSubscriptionRegistrars) { registrars in
				registrars[ObjectIdentifier(E.self)] = registrar
			}
			.onAppear(perform: verifyPublisher)
			.onChange(of: registrars) { _ in verifyPublisher() }
	}
	
	func verifyPublisher() {
		if registrars[ObjectIdentifier(E.self)] == nil { return }
		switch safetyLevel {
		case .strict, .relaxed: print("Registrating duplicate publisher for event \(String(describing: E.self)). This may lead to unexpected behavior.")
		case .disabled: break
		}
	}
}
