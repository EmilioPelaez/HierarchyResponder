//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

struct ErrorHandlerViewModifier: ViewModifier {
	@Environment(\.errorClosure) var errorClosure
	@Environment(\.triggerEvent) var triggerEvent
	
	let handler: (Error) throws -> Event?
	
	func body(content: Content) -> some View {
		content.environment(\.errorClosure) { error in
			Task {
				do {
					if let event = try handler(error) {
						triggerEvent(event)
					}
				} catch {
					errorClosure(error)
				}
			}
		}
	}
}
