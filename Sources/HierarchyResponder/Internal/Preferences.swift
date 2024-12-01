//
//  Created by Emilio Peláez on 18/10/23.
//

import SwiftUI

struct DeclaredEventsKey: PreferenceKey {
	struct Container {
		var events: [any Event.Type]
	}
	
	static var defaultValue: Container = .init(events: [])
	
	static func reduce(value: inout Container, nextValue: () -> Container) {
		value.events.append(contentsOf: nextValue().events)
	}
}

struct DeclaredErrorsKey: PreferenceKey {
	struct Container {
		var errors: [any Error.Type]
	}
	
	static var defaultValue: Container = .init(errors: [])
	
	static func reduce(value: inout Container, nextValue: () -> Container) {
		value.errors.append(contentsOf: nextValue().errors)
	}
}

extension DeclaredEventsKey.Container: Equatable {
	static func == (lhs: DeclaredEventsKey.Container, rhs: DeclaredEventsKey.Container) -> Bool {
		lhs.events.map { String(describing: $0) } == rhs.events.map { String(describing: $0) }
	}
}

extension DeclaredErrorsKey.Container: Equatable {
	static func == (lhs: DeclaredErrorsKey.Container, rhs: DeclaredErrorsKey.Container) -> Bool {
		lhs.errors.map { String(describing: $0) } == rhs.errors.map { String(describing: $0) }
	}
}

struct EventPublisherKey<T: Event>: PreferenceKey {
	static var defaultValue: EventPublisher<T> { .empty }
	
	static func reduce(value: inout EventPublisher<T>, nextValue: () -> EventPublisher<T>) {
		switch value.destination {
		case .firstSubscriber: break
		case .allSubscribers:
			let closure1 = value.publish
			let closure2 = nextValue().publish
			value = .init(destination: value.destination) {
				closure1($0)
				closure2($0)
			}
		case .lastSubscriber:
			value = nextValue()
		}
	}
}
