//
//  EventSubscriberModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

struct EventSubscriberModifier<E: Event>: ViewModifier {
	@Environment(\.eventSubscriptionRegistrars) var registrars
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let eventType: E.Type
	let handler: (E) -> Void
	
	func body(content: Content) -> some View {
		content
			.onAppear(perform: registerPublisher)
			.onChange(of: registrars) { _ in registerPublisher() }
	}
	
	func registerPublisher() {
		guard let registrar = registrars[ObjectIdentifier(E.self)] else {
			let message = "Subscribed to event with no publisher: \(String(describing: E.self))"
			switch safetyLevel {
			case .strict: fatalError(message)
			case .relaxed: return print(message)
			case .disabled: return
			}
		}
		let publisher = EventPublisher<E>(destination: registrar.destination, publish: handler)
		registrar.register(publisher)
	}
}
