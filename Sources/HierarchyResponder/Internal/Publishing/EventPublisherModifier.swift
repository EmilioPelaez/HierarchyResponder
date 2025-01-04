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
	
	init(id: String, destination: PublishingDestination, register: @escaping (EventPublisher<E>?) -> Void) {
		self.id = id
		self.destination = destination
		self.register = register
	}
	
	func body(content: Content) -> some View {
		content
			.publisherRegistrar(for: E.self, id: id, publisher: nil, containers: $containers)
			.onAppearAndChange(of: containers) { containers in
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
		case .firstLevel:
			publishers = containers.map(\.publisher)
		case .allLevels:
			let allContainers = containers.flatMap(\.allContainers)
			publishers = allContainers.map(\.publisher)
		case .lastLevel:
			let lastContainers = lastContainers(in: containers)
			publishers = lastContainers.map(\.publisher)
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
	}
	
	func lastContainers(in containers: Set<PublishersContainer>) -> Set<PublishersContainer> {
		var lastContainers: Set<PublishersContainer> = []
		var depth = 0
		func recursion(_ containers: Set<PublishersContainer>, level: Int) {
			guard !containers.isEmpty else { return }
			if depth == level {
				lastContainers.formUnion(containers)
			} else if level > depth {
				lastContainers = containers
				depth = level
			}
			
			containers
				.map { ($0.containers, level + 1) }
				.forEach(recursion)
		}
		
		recursion(containers, level: 0)
		
		return lastContainers
	}
}

public extension Array {
	subscript(safe index: Index) -> Element? {
		guard index >= 0, index < count else { return nil }
		return self[index]
	}
}
