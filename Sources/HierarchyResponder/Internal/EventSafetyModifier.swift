//
//  Created by Emilio Peláez on 09/10/23.
//

import SwiftUI

struct EventSafetyModifier: ViewModifier {
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let events: [any Event.Type]
	
	func body(content: Content) -> some View {
		content
			.receiveEvent { event in
				let found = events.contains { type(of: event) == $0 }
				if found { return .notHandled }
				switch safetyLevel {
				case .disabled: break
				case .relaxed: print("Received unregistered event \(String(describing: type(of: event)))")
				case .strict: fatalError("Received unregistered event \(String(describing: type(of: event)))")
				}
				return .notHandled
			}
	}
}
