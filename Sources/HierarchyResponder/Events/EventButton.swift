//
//  Created by Emilio Peláez on 24/02/22.
//

import SwiftUI

/*
 A Button that receives, instead of a closure, an Event that will be triggered when
 the underlying Button action would be called
 */
public struct EventButton<Label: View>: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	let event: () -> Event
	let label: () -> Label
	
	init(_ event: @autoclosure @escaping () -> Event, label: @escaping () -> Label) {
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
	init<S: StringProtocol>(_ title: S, event: @autoclosure @escaping () -> Event) {
		self.event = event
		self.label = { Text(title) }
	}
	
	init(_ title: LocalizedStringKey, event: @autoclosure @escaping () -> Event) {
		self.event = event
		self.label = { Text(title) }
	}
}
