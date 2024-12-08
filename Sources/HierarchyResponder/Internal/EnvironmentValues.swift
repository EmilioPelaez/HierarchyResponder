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

struct HandledEventsKey: EnvironmentKey {
	static var defaultValue: [any Event.Type] = []
}

struct HandledErrorsKey: EnvironmentKey {
	static var defaultValue: [any Error.Type] = []
}

struct EventSubscriptionRegistrarsKey: EnvironmentKey {
	static var defaultValue: RegistrarDictionary = [:]
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
	
	var handledEvents: [any Event.Type] {
		get { self[HandledEventsKey.self] }
		set { self[HandledEventsKey.self] = newValue }
	}
	
	var handledErrors: [any Error.Type] {
		get { self[HandledErrorsKey.self] }
		set { self[HandledErrorsKey.self] = newValue }
	}
	
	var eventSubscriptionRegistrars: RegistrarDictionary {
		get { self[EventSubscriptionRegistrarsKey.self] }
		set { self[EventSubscriptionRegistrarsKey.self] = newValue }
	}
}
