//
//  View+Safety.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/24/24.
//

import SwiftUI

extension View {
	func registerHandler(for event: any Event.Type) -> some View {
		transformEnvironment(\.handledEvents) { $0.append(event) }
	}
	
	func registerHandler(for error: any Error.Type) -> some View {
		transformEnvironment(\.handledErrors) { $0.append(error) }
	}
}
