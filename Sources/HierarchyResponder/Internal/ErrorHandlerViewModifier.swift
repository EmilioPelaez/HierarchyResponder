//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

struct ErrorHandlerViewModifier: ViewModifier {
	@Environment(\.reportError) var reportError
	@Environment(\.triggerEvent) var triggerEvent
	
	let handler: (Error) throws -> Event?
	
	func body(content: Content) -> some View {
		content.environment(\.reportError, ReportError { error in
			do {
				if let event = try handler(error) {
					triggerEvent(event)
				}
			} catch {
				reportError(error)
			}
		})
	}
}
