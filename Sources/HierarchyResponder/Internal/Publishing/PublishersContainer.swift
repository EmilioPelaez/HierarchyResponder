//
//  PublishersContainer.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/7/24.
//

import Foundation

struct PublishersContainer: Identifiable, Equatable, Hashable {
	var id: String
	let publisher: any EventPublisherProtocol
	let containers: Set<PublishersContainer>
	
	init(id: String = UUID().uuidString, publisher: any EventPublisherProtocol, containers: Set<PublishersContainer> = []) {
		self.id = id
		self.publisher = publisher
		self.containers = containers
	}
	
	var allContainers: Set<PublishersContainer> {
		Set([self] + containers.flatMap(\.allContainers))
	}
	
	static func == (lhs: PublishersContainer, rhs: PublishersContainer) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
