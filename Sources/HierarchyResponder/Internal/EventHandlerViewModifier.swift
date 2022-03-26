//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

struct EventHandlerViewModifier: ViewModifier {
	@Environment(\.eventClosure) var eventClosure
	@Environment(\.reportError) var reportError
	
	let handler: (Event) throws -> Event?
	
	func body(content: Content) -> some View {
		content.environment(\.eventClosure) {
			do {
				if let event = try handler($0) {
					eventClosure(event)
				}
			} catch {
				reportError(error)
			}
		}
	}
}
