//
//  EventPublisherModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

typealias RegistrarDictionary = [ObjectIdentifier: [EventSubscriptionRegistrar]]

/**
 The `EventPublisherModifier` introduces a "registrar" into the environment
 associated with the event type, this registrar enables for views down the
 chain to register an `EventPublisher`. Once this happens the publishers are
 passed to the caller of the modifier via the `register` closure.
 This object can then publish events by executing the closure in the
 `EventPublisher`.
 */
struct EventPublisherModifier<E: Event>: ViewModifier {
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let id: String
	let destination: PublishingDestination
	let register: (EventPublisher<E>?) -> Void
	
	@State var containers: Set<PublishersContainer> = []
	
	init(id: String = UUID().uuidString, destination: PublishingDestination, register: @escaping (EventPublisher<E>?) -> Void) {
		self.id = id
		self.destination = destination
		self.register = register
	}
	
	func body(content: Content) -> some View {
		content
			.publisherRegistrar(for: E.self, childContainers: $containers)
			.onChange(of: containers) { containers in
				updatePublisher(containers: containers, destination: destination)
			}
			.onChange(of: destination) { destination in
				updatePublisher(containers: containers, destination: destination)
			}
			.onDisappear { register(nil) }
	}
	
	func updatePublisher(containers: Set<PublishersContainer>, destination: PublishingDestination) {
		print(containers)
//		let publishers = container?.publishers.compactMap { $0 as? EventPublisher<E> } ?? []
//		guard !publishers.isEmpty else { return register(nil) }
//		print("Publishers", publishers.count, publishers.map(\.id))
//		let publisher: EventPublisher<E>?
//		switch destination {
//		case .firstSubscriber:
//			publisher = publishers.first
//		case .allSubscribers:
//			publisher = .init { event in
//				publishers.forEach { $0.publish(event) }
//			}
//		case .lastSubscriber:
//			publisher = publishers.last
//		}
//		register(publisher)
	}
}
