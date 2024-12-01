//
//  EventPublisher.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

/**
 `PublishingDestination` is used in the `.publisher` view modifier to specify
 which publishers should receive the event.
 
 The order is determined by the order they are declared in the view hierarchy.
 */
public enum PublishingDestination {
	case firstSubscriber
	case allSubscribers
	case lastSubscriber
	
	public static var `default`: PublishingDestination { .lastSubscriber }
}

/**
 `EventPublishers` are not created directly, instead they are received when using
 the `.publisher` view modifier.
 
 `EventPublishers` are designed to be stored and used to inject events into the
 view hierarchy.
 
 Because they implement `callAsFunction` they can be called like this:
 ```
 publisher(MyEvent())
 ```
 */
public struct EventPublisher<T: Event>: Equatable {
	static var empty: Self { .init(destination: .default) { _ in } }
	
	public let id: UUID
	let destination: PublishingDestination
	public let publish: (T) -> Void
	
	init(id: UUID = .init(), destination: PublishingDestination, publish: @escaping (T) -> Void) {
		self.id = id
		self.destination = destination
		self.publish = publish
	}
	
	public func callAsFunction(_ event: T) -> Void {
		publish(event)
	}
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.id == rhs.id
	}
}
