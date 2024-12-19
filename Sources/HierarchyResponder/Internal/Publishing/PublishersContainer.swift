//
//  PublishersContainer.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/7/24.
//

import Foundation

struct PublishersContainer: Identifiable, Equatable {
	var id: UUID = .init()
	let publishers: [any EventPublisherProtocol]
	
	static func == (lhs: PublishersContainer, rhs: PublishersContainer) -> Bool {
		lhs.id == rhs.id
	}
}
