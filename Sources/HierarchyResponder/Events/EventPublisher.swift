//
//  EventPublisher.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

public enum PublishingDestination {
	case firstSubscriber
	case allSubscribers
	case lastSubscriber
	
	public static var `default`: PublishingDestination { .lastSubscriber }
}

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
