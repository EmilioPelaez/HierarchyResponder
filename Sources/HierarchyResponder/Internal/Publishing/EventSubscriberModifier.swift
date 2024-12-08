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
	
	let publisher: EventPublisher<E>
	@State var registrar: EventSubscriptionRegistrar
	@State var container: PublishersContainer?
	
	var updatedRegistrars: [ObjectIdentifier: EventSubscriptionRegistrar] {
		var registrars = registrars
		registrars[ObjectIdentifier(E.self)] = registrar
		return registrars
	}
	
	init(eventType: E.Type, handler: @escaping (E) -> Void) {
		publisher = .init(publish: handler)
		self.registrar = .init { _ in }
	}
	
	func body(content: Content) -> some View {
		content
			.onAppear(perform: createRegistrar)
			.onAppearAndChange(of: registrars, perform: registerPublisher)
			.onDisappear(perform: unregisterPublisher)
			.environment(\.eventSubscriptionRegistrars, updatedRegistrars)
	}
	
	func createRegistrar() {
		registrar = .init { container = $0 }
	}
	
	func registerPublisher(_ registrars: RegistrarDictionary) {
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
		registrar.register(container)
	}
	
	func unregisterPublisher() {
		registrars[ObjectIdentifier(E.self)]?.register(.init(publishers: []))
	}
}
