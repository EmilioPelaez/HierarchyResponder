//
//  Created by Emilio Peláez on 09/10/23.
//

import SwiftUI

/**
 The safety level that will be used when using the `triggers` and `reports`
 view modifiers.
 */
public enum ResponderSafetyLevel {
	/// `strict` will trigger a `fatalError` when safety conditions are not met
	case strict
	/// `relax` will show a console warning when safety conditions are not met
	case relaxed
	/// `disabled` will have no actions when safety confitions are not met
	case disabled
	
	public static let `default` = ResponderSafetyLevel.relaxed
}

public extension View {
	/**
	 The `triggers` modifier declares the types of the events that are expected to
	 be triggered by the descendants of the modified view.
	 
	 It is used to document the behavior of the view, and also acts as a runtime
	 check by raising a warning when an event that was not declared is detected,
	 and when explicit responders are required (enabled by default) by raising a
	 warning if there are no responders for these specific events above in the
	 hierarchy.
	 */
	func triggers(_ events: any Event.Type..., file: String = #file, line: Int = #line) -> some View {
#if DEBUG
		modifier(EventSafetyModifier(events: events, location: "\(file):\(line)"))
#else
		self
#endif
	}
	
	/**
	 The `reports` modifier declares the types of the errors that are expected to
	 be triggered by the descendants of the modified view.
	 
	 It is used to document the behavior of the view, and also acts as a runtime
	 check by raising a warning when an event that was not declared is detected,
	 and when explicit responders are required (enabled by default) by raising a
	 warning if there are no responders for these specific errors above in the
	 hierarchy.
	 */
	func reports(_ errors: any Error.Type..., file: String = #file, line: Int = #line) -> some View {
#if DEBUG
		modifier(ErrorSafetyModifier(errors: errors, location: "\(file):\(line)"))
#else
		self
#endif
	}
	
	/**
	 Sets the responder safety level for all the descendants in the view hierarchy.
	 
	 The default, `relaxed`, will only log console warnings, while `strict` will
	 trigger a `fatalError`.
	 
	 This will only work when the `triggers` and `reports` modifiers are used.
	 */
	func responderSafetyLevel(_ level: ResponderSafetyLevel) -> some View {
		environment(\.responderSafetyLevel, level)
	}
	
	/**
	 Require explicit responders is enabled by default, and when using the
	 `triggers` and `reports` modifiers, it will throw raise an error when an
	 event or error is declared that doesn't have a matching explicit responder in
	 the view hierarchy.
	 
	 Explicit responders are all the responders that receive a type as their
	 first argument:
	 
	 ```
	 .handleEvent(MyEvent.self) { ... }
	 ```
	 */
	func requireExplicitResponders(_ flag: Bool) -> some View {
		environment(\.requiresExplicitResponders, flag)
	}
}
