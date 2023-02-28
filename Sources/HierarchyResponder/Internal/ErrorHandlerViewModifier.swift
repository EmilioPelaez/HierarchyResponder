//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

struct ErrorHandlerViewModifier: ViewModifier {
	@Environment(\.reportError) var reportError
	@Environment(\.triggerEvent) var triggerEvent
	
	let handler: (Error) async throws -> Event?
	
	@State var tasks: [Task<Void, Never>] = []
	
	func body(content: Content) -> some View {
		content.environment(\.reportError, ReportError { error in
			let task = Task {
				do {
					if let event = try await handler(error) {
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
