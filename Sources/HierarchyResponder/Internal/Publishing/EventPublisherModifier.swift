//
//  EventPublisherModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

typealias RegistrarDictionary = [ObjectIdentifier: EventSubscriptionRegistrar]

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
		guard !containers.isEmpty else { return register(nil) }
		let publishers: [any EventPublisherProtocol]
		switch destination {
		case .firstSubscriber:
			publishers = containers.map(\.publisher)
		case .allSubscribers:
			let allContainers = containers.flatMap(\.allContainers)
			publishers = allContainers.map(\.publisher)
		case .lastSubscriber:
			fatalError()
		}
		let filteredPublishers = publishers.compactMap { $0 as? EventPublisher<E> }
		guard filteredPublishers.count == publishers.count else {
			assertionFailure("Some publishers were droped")
			return
		}
		let publisher = EventPublisher<E>(id: id) { event in
			filteredPublishers.forEach { $0.publish(event) }
		}
		register(publisher)
		print("Registered \(filteredPublishers.count) publishers with IDs \(filteredPublishers.map(\.id))")
	}
}
