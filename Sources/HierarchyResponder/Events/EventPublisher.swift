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
public struct EventPublisher<T: Event>: Identifiable, Equatable {
	public let id: UUID = .init()
	
	static var empty: Self { .init { _ in } }
	
	public let publish: (T) -> Void
	
	init(publish: @escaping (T) -> Void) {
		self.publish = publish
	}
	
	public func callAsFunction(_ event: T) -> Void {
		publish(event)
	}
	
	public static func == (lhs: EventPublisher, rhs: EventPublisher) -> Bool {
		lhs.id == rhs.id
	}
}
