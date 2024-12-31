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
 
 The "level" of each value refers to the depth of the subscriber in the view
 hierarchy, the first level being the subscribers declared closest to the
 publisher.
 
 Using container views (like Group, etc.) will create multiple subscribers at
 the same level. For example, adding a `.subscribe` modifier to all the cells
 in a list could cause all of them to share the last/deepest level of
 subscribers in the hierarchy.
 
 The order in which subscribers are called when publishing an event is not
 guaranteed to be stable.
 */
public enum PublishingDestination {
	/**
	 Publishers at the shallowest level of the hierarchy
	 */
	case firstLevel
	/**
	 Publishers at all the levels of the hierarchy
	 */
	case allLevels
	/**
	 Publishers at the deepest level of the hierarchy
	 */
	case lastLevel
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
	public let id: String
	
	static var empty: Self { .init { _ in } }
	
	public let publish: (T) -> Void
	
	init(id: String = UUID().uuidString, publish: @escaping (T) -> Void) {
		self.id = id
		self.publish = publish
	}
	
	public func callAsFunction(_ event: T) -> Void {
		publish(event)
	}
	
	public static func == (lhs: EventPublisher, rhs: EventPublisher) -> Bool {
		lhs.id == rhs.id
	}
}
