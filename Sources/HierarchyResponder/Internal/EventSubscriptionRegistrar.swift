//
//  EventPublisherSubscriber.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/5/24.
//

import SwiftUI

protocol EventPublisherProtocol {}

extension EventPublisher: EventPublisherProtocol{}

struct EventSubscriptionRegistrar: Identifiable, Equatable {
	let id: UUID = .init()
	
	let destination: PublishingDestination
	let register: (EventPublisherProtocol) -> Void
	
	init(destination: PublishingDestination, register: @escaping (EventPublisherProtocol) -> Void) {
		self.destination = destination
		self.register = register
	}
	
	static func == (lhs: EventSubscriptionRegistrar, rhs: EventSubscriptionRegistrar) -> Bool {
		lhs.id == rhs.id
	}
}
