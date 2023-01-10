//
//  Created by Emilio Peláez on 10/1/23.
//

import SwiftUI

struct TapGestureEvent: ViewModifier {
	@Environment(\.triggerEvent) var triggerEvent
	
	let tapCount: Int
	let event: () -> Event
	
	func body(content: Content) -> some View {
		content
			.onTapGesture(count: tapCount) {
				triggerEvent(event())
			}
	}
}

public extension View {
	func onTapGesture(count: Int = 1, trigger event: @escaping @autoclosure () -> Event) -> some View {
		modifier(TapGestureEvent(tapCount: count, event: event))
	}
}
