//
//  EventPublisherModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

public extension View {
	func publisher<E: Event>(for event: E.Type, destination: PublishingDestination = .default, register: @escaping (EventPublisher<E>) -> Void) -> some View {
		modifier(EventPublisherModifier(eventType: event, destination: destination, register: register))
	}
	
	func subscribe<E: Event>(to event: E.Type, handler: @escaping (E) -> Void) -> some View {
		modifier(EventSubscriberModifier(eventType: event, handler: handler))
	}
}

public enum PublishingDestination {
	case firstSubscriber
	case allSubscribers
	case lastSubscriber
	
	public static var `default`: PublishingDestination { .lastSubscriber }
}

struct EventPublisherModifier<E: Event>: ViewModifier {
	@Environment(\.publishingDestinations) var publishingDestinations
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let eventType: E.Type
	let destination: PublishingDestination
	let register: (EventPublisher<E>) -> Void
	
	func body(content: Content) -> some View {
		content
			.onPreferenceChange(EventPublisherPreference<E>.self, perform: register)
			.transformEnvironment(\.publishingDestinations) { destinations in
				destinations[ObjectIdentifier(eventType)] = destination
			}
			.onAppear(perform: verifyPublisher)
			.onChange(of: publishingDestinations) { _ in verifyPublisher() }
	}
	
	func verifyPublisher() {
		if publishingDestinations[ObjectIdentifier(eventType)] == destination { return }
		switch safetyLevel {
		case .strict, .relaxed: print("Registrating duplicate publisher for event \(String(describing: eventType)) using a different destination. This may lead to unexpected behavior.")
		case .disabled: break
		}
	}
}

struct EventSubscriberModifier<E: Event>: ViewModifier {
	@Environment(\.publishingDestinations) var publishingDestinations
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let eventType: E.Type
	let handler: (E) -> Void
	
	var destination: PublishingDestination {
		publishingDestinations[ObjectIdentifier(eventType)] ?? .default
	}
	
	func body(content: Content) -> some View {
		content
			.preference(key: EventPublisherPreference<E>.self,
									value: EventPublisher<E>(destination: destination, publish: handler))
			.onAppear(perform: verifyPublisher)
			.onChange(of: publishingDestinations) { _ in verifyPublisher() }
	}
	
	func verifyPublisher() {
		if publishingDestinations[ObjectIdentifier(eventType)] != nil { return }
		switch safetyLevel {
		case .strict: fatalError("Subscribed to event with no publisher: \(String(describing: eventType))")
		case .relaxed: print("Subscribed to event with no publisher: \(String(describing: eventType))")
		case .disabled: break
		}
	}
}

struct EventPublisherPreference<T: Event>: PreferenceKey {
	static var defaultValue: EventPublisher<T> { .empty }
	
	static func reduce(value: inout EventPublisher<T>, nextValue: () -> EventPublisher<T>) {
		switch value.destination {
		case .firstSubscriber: break
		case .allSubscribers:
			let closure1 = value.publish
			let closure2 = nextValue().publish
			value = .init(destination: value.destination) {
				closure1($0)
				closure2($0)
			}
		case .lastSubscriber:
			value = nextValue()
		}
	}
}

public struct EventPublisher<T: Event>: Equatable {
	static var empty: Self { .init(destination: .default) { _ in } }
	
	public let id: UUID
	public let destination: PublishingDestination
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
