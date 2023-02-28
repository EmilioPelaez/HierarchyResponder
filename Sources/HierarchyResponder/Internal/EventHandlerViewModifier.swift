//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

struct EventHandlerViewModifier: ViewModifier {
	@Environment(\.triggerEvent) var triggerEvent
	@Environment(\.reportError) var reportError
	
	let handler: (Event) async throws -> Event?
	
	@State var tasks: [Task<Void, Never>] = []
	
	func body(content: Content) -> some View {
		content.environment(\.triggerEvent, TriggerEvent { prev in
			let task = Task {
				do {
					if let event = try await handler(prev) {
						triggerEvent(event)
					}
				} catch {
					guard !Task.isCancelled else { return }
					reportError(error)
				}
			}
			tasks.append(task)
		})
		.onDisappear {
			tasks.forEach {
				$0.cancel()
			}
			tasks = []
		}
	}
	
}
