//
//  EventPublisherModifier.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

public extension View {
	func publisher<E: Event>(for event: E.Type, register: @escaping (EventPublisher<E>) -> Void) -> some View {
		modifier(EventPublisherModifier(eventType: event, register: register))
	}
	
	func subscribe<E: Event>(to event: E.Type, handler: @escaping (E) -> Void) -> some View {
		modifier(EventSubscriberModifier(eventType: event, handler: handler))
	}
}

struct EventPublisherModifier<E: Event>: ViewModifier {
	let eventType: E.Type
	let register: (EventPublisher<E>) -> Void
	
	func body(content: Content) -> some View {
		content
			.onPreferenceChange(EventPublisherPreference<E>.self) { value in
				register(value)
			}
	}
}

struct EventSubscriberModifier<E: Event>: ViewModifier {
	let eventType: E.Type
	let handler: (E) -> Void
	
	func body(content: Content) -> some View {
		content
			.preference(key: EventPublisherPreference<E>.self,
									value: EventPublisher<E>(publish: handler))
	}
}

struct EventPublisherPreference<T: Event>: PreferenceKey {
	static var defaultValue: EventPublisher<T> { .empty }
	
	static func reduce(value: inout EventPublisher<T>, nextValue: () -> EventPublisher<T>) {
//		value = nextValue()
//		let closure1 = value.publish
//		let closure2 = nextValue().publish
//		value = .init {
//			closure1($0)
//			closure2($0)
//		}
	}
}

public struct EventPublisher<T: Event>: Equatable {
	static var empty: Self { .init(id: .init()) { _ in } }
	
	public let id: UUID
	public let publish: (T) -> Void
	
	init(id: UUID = .init(), publish: @escaping (T) -> Void) {
		self.id = id
		self.publish = publish
	}
	
	public func callAsFunction(_ event: T) -> Void {
		publish(event)
	}
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.id == rhs.id
	}
}
