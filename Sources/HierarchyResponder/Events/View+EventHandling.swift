//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

/**
 When a `View` registers a closure using the `receiveEvent` modifier, the
 closure should return `.handled` when the `Event` has been handled, and
 should no longer be propagated up the view hierarchy, and `.notHandled` when
 the `Event` has not been completely handled.
 */
public enum ReceiveEventResult {
	case handled
	case notHandled
}

public extension View {
	
	/**
	 Registers a closure to receive all `Events` triggered using the
	 `triggerEvent` Environment closure.
	 
	 The registered closure should return `.handled` when the `Event` has been
	 handled, and should no longer be propagated up the view hierarchy, and
	 `.notHandled` when the `Event` has not been completely handled.
	 */
	func receiveEvent(_ closure: @escaping (Event) throws -> ReceiveEventResult) -> some View {
		let handlerModifier = EventHandlerViewModifier {
			switch try closure($0) {
			case .handled: return nil
			case .notHandled: return $0
			}
		}
		return modifier(handlerModifier)
	}
	
	/**
	 Registers a closure to receive `Events` of the supplied type triggered using
	 the `triggerEvent` Environment closure.
	 
	 The registered closure should return `.handled` when the `Event` has been
	 handled, and should no longer be propagated up the view hierarchy, and
	 `.notHandled` when the `Event` has not been completely handled.
	 */
	func receiveEvent<Received: Event>(_: Received.Type, closure: @escaping (Received) throws -> ReceiveEventResult) -> some View {
		let handlerModifier = EventHandlerViewModifier {
			guard let event = $0 as? Received else { return $0 }
			switch try closure(event) {
			case .handled: return nil
			case .notHandled: return $0
			}
		}
		return modifier(handlerModifier)
	}
	
	/**
	 Registers a closure to receive `Events` of the supplied type triggered using
	 the `triggerEvent` Environment closure.
	 
	 The registered closure should return `.handled` when the `Event` has been
	 handled, and should no longer be propagated up the view hierarchy, and
	 `.notHandled` when the `Event` has not been completely handled.
	 */
	func receiveEvent<Received: Event>(_ type: Received.Type, closure: @escaping () throws -> ReceiveEventResult) -> some View {
		receiveEvent(type) { _ in try closure() }
	}
	
	/**
	 Registers a closure to handle all `Events` triggered using the
	 `triggerEvent` Environment closure.
	 
	 Using this modifier will effectively **stop the propagation of all events
	 up the view hierarchy.**
	 */
	func handleEvent(_ handler: @escaping (Event) throws -> Void) -> some View {
		receiveEvent {
			try handler($0)
			return .handled
		}
	}
	
	/**
	 Registers a closure to handle `Events` of the supplied type triggered using
	 the `triggerEvent` Environment closure.
	 
	 `Events` of the supplied type will be passed to the handling closure and no
	 longer propagated up the view hierarhcy.
	 
	 Any other `Events` will be ignored and propagated up the view hierarchy.
	 */
	func handleEvent<Handled: Event>(_ type: Handled.Type, handler: @escaping (Handled) throws -> Void) -> some View {
		receiveEvent(type) {
			try handler($0)
			return .handled
		}
	}
	
	/**
	 Registers a closure to handle `Events` of the supplied type triggered using
	 the `triggerEvent` Environment closure.
	 
	 `Events` of the supplied type will be passed to the handling closure and no
	 longer propagated up the view hierarhcy.
	 
	 Any other `Events` will be ignored and propagated up the view hierarchy.
	 */
	func handleEvent<Handled: Event>(_ type: Handled.Type, handler: @escaping () throws -> Void) -> some View {
		handleEvent(type) { _ in try handler() }
	}
	
	/**
	 Registers a closure to transform all `Events` triggered using the
	 `triggerEvent` Environment closure.
	 
	 The closure should return an `Event` that can be a new `Event` or the same
	 `Event` that was supplied as a parameter.
	 */
	func transformEvent(_ transform: @escaping (Event) throws -> Event) -> some View {
		modifier(EventHandlerViewModifier(handler: transform))
	}
	
	/**
	 Registers a closure to transform `Events` of the supplied type triggered
	 using the `triggerEvent` Environment closure.
	 
	 The closure should return an `Event` that can be a new `Event` or the same
	 `Event` that was supplied as a parameter.
	 */
	func transformEvent<Transformed: Event>(_: Transformed.Type, transform: @escaping (Transformed) throws -> Event) -> some View {
		let transformModifier = EventHandlerViewModifier {
			guard let event = $0 as? Transformed else { return $0 }
			return try transform(event)
		}
		return modifier(transformModifier)
	}
	
	/**
	 Registers a closure to transform `Events` of the supplied type triggered
	 using the `triggerEvent` Environment closure.
	 
	 The closure should return a new `Event` that will be propagated up the view
	 hierarchy.
	 */
	func transformEvent<Transformed: Event>(_ type: Transformed.Type, transform: @escaping () throws -> Event) -> some View {
		transformEvent(type) { _ in try transform() }
	}
	
}
