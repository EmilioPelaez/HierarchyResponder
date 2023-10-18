//
//  Created by Emilio Peláez on 09/10/23.
//

import SwiftUI

struct ErrorSafetyModifier: ViewModifier {
	@Environment(\.requiresExplicitResponders) var requiresExplicitResponders
	@Environment(\.responderSafetyLevel) var safetyLevel
	
	@Environment(\.handledErrors) var receivedErrors
	
	let errors: [any Error.Type]
	let location: String
	
	@State var declaredErrors: [any Error.Type] = []
	
	var allDeclaredErrors: [any Error.Type] {
		errors + declaredErrors
	}
	
	func body(content: Content) -> some View {
		content
			.receiveError { error in
				let found = errors.contains { type(of: error) == $0 }
				if found { return .notHandled }
				switch safetyLevel {
				case .disabled: break
				case .relaxed: print("Received unregistered error \(String(describing: type(of: error))) at \(location)")
				case .strict: fatalError("Received unregistered error \(String(describing: type(of: error))) at \(location)")
				}
				return .notHandled
			}
			.onPreferenceChange(DeclaredErrorsKey.self) { value in declaredErrors = value.errors }
			.preference(key: DeclaredErrorsKey.self, value: .init(errors: allDeclaredErrors))
			.onAppear {
				guard requiresExplicitResponders else { return }
				let unregistered = errors.filter { event in
					!receivedErrors.contains { $0 == event }
				}
				if unregistered.isEmpty { return }
				let errorsString = unregistered.map { String(describing: $0) }.joined(separator: ", ")
				switch safetyLevel {
				case .disabled: break
				case .relaxed: print("The following errors don't have a registered handler: " + errorsString)
				case .strict: fatalError("The following errors don't have a registered handler: " + errorsString)
				}
			}
	}
}
