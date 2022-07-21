//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

struct EventHandlerViewModifier: ViewModifier {
	@Environment(\.triggerEvent) var triggerEvent
	@Environment(\.reportError) var reportError
	
	let handler: (Event) throws -> Event?
	
	func body(content: Content) -> some View {
		content.environment(\.triggerEvent, TriggerEvent {
			do {
				if let event = try handler($0) {
					triggerEvent(event)
				}
			} catch {
				reportError(error)
			}
		})
	}
}
