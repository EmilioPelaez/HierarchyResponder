//
//  View+EventPublishing.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/1/24.
//

import SwiftUI

/**
 WARNING: The `publisher` and `subscribe` modifiers are experimental features
 */

public extension View {
	/**
	 EXPERIMENTAL.
	 Publishing events enables sending events to views that are lower in the view
	 hierarchy. This can be really useful when working with events that are
	 originated from outside of the view hierarchy, like menu bar actions, intents,
	 deep linking, navigation events, shake events, etc.
	 
	 When you use the `publisher` modifier you receive an `EventPublisher`
	 object that you can use to inject events into the view hierarchy. You should
	 store this publisher and be ready to update the reference when you receive a
	 new one.
	 
	 ```
	 @StateObject var controller: ExternalEventController
	 
	 var body: some View {
		 Text("Hello")
		  .publisher(MyEvent.self) { controller.publisher = $0 }
	 }
	 ```
	 
	 The destination parameter determines which subscriber will receive the event
	 once it's published. The order of the subscribers is determined by the order
	 in which they were added to the view hierarchy.
	 */
	func publisher<E: Event>(for event: E.Type, id: String, destination: PublishingDestination = .lastLevel, register: @escaping (EventPublisher<E>?) -> Void) -> some View {
		modifier(EventPublisherModifier(id: id, destination: destination, register: register))
	}
	
	/**
	 EXPERIMENTAL.
	 Subscribing to an event will cause the hadler closure to be executed when an
	 event is published, as long as the current subscriber matches the event's
	 destination.
	 */
	func subscribe<E: Event>(to event: E.Type, id: String, handler: @escaping (E) -> Void) -> some View {
		modifier(EventSubscriberModifier(id: id, eventType: event, handler: handler))
	}
}
