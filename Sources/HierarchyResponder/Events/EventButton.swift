//
//  Created by Emilio Peláez on 24/02/22.
//

import SwiftUI

/**
 A Button that receives, instead of an action closure, an `Event` that will be
 triggered when the underlying Button's action would be called.
 */
public struct EventButton<Label: View>: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	let event: () -> Event
	let label: () -> Label
	
	/// Creates a button that displays a custom label, and triggers an event when
	/// the underlying button's action would be triggered.
	public init(_ event: @autoclosure @escaping () -> Event, label: @escaping () -> Label) {
		self.event = event
		self.label = label
	}
	
	public var body: some View {
		Button(action: action) { label() }
	}
	
	func action() {
		triggerEvent(event())
	}
}

public extension EventButton where Label == Text {
	/// Creates a button that generates its label the provided string.
	init<S: StringProtocol>(_ title: S, event: @autoclosure @escaping () -> Event) {
		self.event = event
		self.label = { Text(title) }
	}
	
	/// Creates a button that generates its label from a localized string key.
	init(_ title: LocalizedStringKey, event: @autoclosure @escaping () -> Event) {
		self.event = event
		self.label = { Text(title) }
	}
}
