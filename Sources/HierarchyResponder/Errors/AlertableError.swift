//
//  Created by Emilio Peláez on 30/12/21.
//

/**
 An error that can be displayed to the user in an alert.
 */
public protocol AlertableError: Error {
	/// An optional user-friendly title for the error
	var title: String? { get }
	/// A user-friendly message describing the error
	var message: String { get }
}

public extension AlertableError {
	var title: String? { nil }
}

extension AlertableError {
	func typeErased() -> AnyAlertableError {
		AnyAlertableError(title: title, message: message)
	}
}

struct AnyAlertableError: AlertableError {
	var title: String?
	var message: String
}
