//
//  EventPublisherSubscriber.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/5/24.
//

import SwiftUI

protocol EventPublisherProtocol: Identifiable {
	var id: String { get }
}
extension EventPublisher: EventPublisherProtocol {}

struct EventSubscriptionRegistrar: Identifiable, Equatable {
	let id: String
	let register: (String, PublishersContainer?) -> Void
	
	init(id: String = UUID().uuidString, register: @escaping (String, PublishersContainer?) -> Void) {
		self.id = id
		self.register = register
	}
	
	static func == (lhs: EventSubscriptionRegistrar, rhs: EventSubscriptionRegistrar) -> Bool {
		lhs.id == rhs.id
	}
}
