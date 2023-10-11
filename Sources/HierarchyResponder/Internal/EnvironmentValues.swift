//
//  Created by Emilio Peláez on 26/03/22.
//

import SwiftUI

struct ErrorClosureEnvironmentKey: EnvironmentKey {
	static var defaultValue: ReportError = .init { error in
		assertionFailure("Unhandled Error \(error)")
	}
}

struct EventClosureEnvironmentKey: EnvironmentKey {
	static var defaultValue: TriggerEvent = .init { _ in }
}

struct ResponderSafetyLevelKey: EnvironmentKey {
	static var defaultValue: ResponderSafetyLevel = .default
}

struct RequiresExplicitRespondersKey: EnvironmentKey {
	static var defaultValue = true
}

struct RegisteredEventsKey: EnvironmentKey {
	static var defaultValue: [any Event.Type] = []
}

struct RegisteredErrorsKey: EnvironmentKey {
	static var defaultValue: [any Error.Type] = []
}

extension EnvironmentValues {
	var responderSafetyLevel: ResponderSafetyLevel {
		get { self[ResponderSafetyLevelKey.self] }
		set { self[ResponderSafetyLevelKey.self] = newValue }
	}
	
	var requiresExplicitResponders: Bool {
		get { self[RequiresExplicitRespondersKey.self] }
		set { self[RequiresExplicitRespondersKey.self] = newValue }
	}
	
	var registeredEvents: [any Event.Type] {
		get { self[RegisteredEventsKey.self] }
		set { self[RegisteredEventsKey.self] = newValue }
	}
	
	var registeredErrors: [any Error.Type] {
		get { self[RegisteredErrorsKey.self] }
		set { self[RegisteredErrorsKey.self] = newValue }
	}
}
