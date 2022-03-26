//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

/**
 When a `View` registers a closure using the `receiveError` modifier, the
 closure should return `.handled` when the `Error` has been handled, and
 should no longer be propagated up the view hierarchy, and `.notHandled` when
 the `Error` has not been completely handled.
 */
public enum ReceiveErrorResult {
	case handled
	case notHandled
}

public extension View {
	
	/**
	 Registers a closure to receive all `Errors` triggered using the
	 `triggerError` Environment closure.
	 
	 The registered closure should return `.handled` when the `Error` has been
	 handled, and should no longer be propagated up the view hierarchy, and
	 `.notHandled` when the `Error` has not been completely handled.
	 */
	func receiveError(_ closure: @escaping (Error) -> ReceiveErrorResult) -> some View {
		let handlerModifier = ErrorHandlerViewModifier {
			switch closure($0) {
			case .handled: return nil
			case .notHandled: throw $0
			}
		}
		return modifier(handlerModifier)
	}
	
	/**
	 Registers a closure to receive `Errors` of the supplied type triggered using
	 the `triggerError` Environment closure.
	 
	 The registered closure should return `.handled` when the `Error` has been
	 handled, and should no longer be propagated up the view hierarchy, and
	 `.notHandled` when the `Error` has not been completely handled.
	 */
	func receiveError<Received: Error>(_: Received.Type, closure: @escaping (Received) -> ReceiveErrorResult) -> some View {
		let handlerModifier = ErrorHandlerViewModifier {
			guard let received = $0 as? Received else {
				throw $0
			}
			switch closure(received) {
			case .handled: return nil
			case .notHandled: throw received
			}
		}
		return modifier(handlerModifier)
	}
	
	/**
	 Registers a closure to receive `Errors` of the supplied type triggered using
	 the `triggerError` Environment closure.
	 
	 The registered closure should return `.handled` when the `Error` has been
	 handled, and should no longer be propagated up the view hierarchy, and
	 `.notHandled` when the `Error` has not been completely handled.
	 */
	func receiveError<Received: Error>(_ type: Received.Type, closure: @escaping () -> ReceiveErrorResult) -> some View {
		receiveError(type) { _ in closure() }
	}
	
	/**
	 Registers a closure to handle all `Errors` triggered using the
	 `triggerError` Environment closure.
	 
	 Using this modifier will effectively **stop the propagation of all errors
	 up the view hierarchy.**
	 */
	func handleError(_ handler: @escaping (Error) -> Void) -> some View {
		receiveError {
			handler($0)
			return .handled
		}
	}
	
	/**
	 Registers a closure to handle `Errors` of the supplied type triggered using
	 the `triggerError` Environment closure.
	 
	 `Errors` of the supplied type will be passed to the handling closure and no
	 longer propagated up the view hierarhcy.
	 
	 Any other `Errors` will be ignored and propagated up the view hierarchy.
	 */
	func handleError<Handled: Error>(_: Handled.Type, handler: @escaping (Handled) -> Void) -> some View {
		receiveError {
			guard let error = $0 as? Handled else {
				return .notHandled
			}
			handler(error)
			return .handled
		}
	}
	
	/**
	 Registers a closure to handle `Errors` of the supplied type triggered using
	 the `triggerError` Environment closure.
	 
	 `Errors` of the supplied type will be passed to the handling closure and no
	 longer propagated up the view hierarhcy.
	 
	 Any other `Errors` will be ignored and propagated up the view hierarchy.
	 */
	func handleError<Handled: Error>(_ type: Handled.Type, handler: @escaping () -> Void) -> some View {
		handleError(type) { _ in handler() }
	}
	
	/**
	 Registers a closure to transform all `Errors` triggered using the
	 `triggerError` Environment closure.
	 
	 The closure should return an `Error` that can be a new `Error` or the same
	 `Error` that was supplied as a parameter.
	 */
	func transformError(_ transform: @escaping (Error) -> Error) -> some View {
		let transformModifier = ErrorHandlerViewModifier {
			throw transform($0)
		}
		return modifier(transformModifier)
	}
	
	/**
	 Registers a closure to transform `Errors` of the supplied type triggered
	 using the `triggerError` Environment closure.
	 
	 The closure should return an `Error` that can be a new `Error` or the same
	 `Error` that was supplied as a parameter.
	 */
	func transformError<Transformable: Error>(_: Transformable.Type, transform: @escaping (Transformable) -> Error) -> some View {
		let transformModifier = ErrorHandlerViewModifier {
			guard let transformable = $0 as? Transformable else {
				throw $0
			}
			let error = transform(transformable)
			throw error
		}
		return modifier(transformModifier)
	}
	
	/**
	 Registers a closure to transform `Errors` of the supplied type triggered
	 using the `triggerError` Environment closure.
	 
	 The closure should return a new `Error` that will be propagated up the view
	 hierarchy.
	 */
	func transformError<Transformable: Error>(_ type: Transformable.Type, transform: @escaping () -> Error) -> some View {
		transformError(type) { _ in transform() }
	}
		
}
