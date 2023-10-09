//
//  Created by Emilio Peláez on 09/10/23.
//

import SwiftUI

struct ErrorSafetyModifier: ViewModifier {
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	let errors: [any Error.Type]
	
	func body(content: Content) -> some View {
		content
			.receiveError { error in
				let found = errors.contains { type(of: error) == $0 }
				if found { return .notHandled }
				switch safetyLevel {
				case .disabled: break
				case .relaxed: print("Received unregistered error \(String(describing: type(of: error)))")
				case .strict: fatalError("Received unregistered error \(String(describing: type(of: error)))")
				}
				return .notHandled
			}
	}
}
