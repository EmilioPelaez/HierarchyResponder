//
//  View+EventPublishing.swift
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
