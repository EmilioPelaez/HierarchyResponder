//
//  Created by Emilio Peláez on 09/10/23.
//

import SwiftUI

public enum ResponderSafetyLevel {
	case strict
	case relaxed
	case disabled
	
	public static let `default` = ResponderSafetyLevel.relaxed
}

public extension View {
	
	func triggers(_ events: any Event.Type..., file: String = #file, line: Int = #line) -> some View {
#if DEBUG
		modifier(EventSafetyModifier(events: events, location: "\(file):\(line)"))
#else
		self
#endif
	}
	
	func reports(_ errors: any Error.Type..., file: String = #file, line: Int = #line) -> some View {
#if DEBUG
		modifier(ErrorSafetyModifier(errors: errors, location: "\(file):\(line)"))
#else
		self
#endif
	}
	
	func responderSafetyLevel(_ level: ResponderSafetyLevel) -> some View {
		environment(\.responderSafetyLevel, level)
	}
	
	func registerHandler(for event: any Event.Type) -> some View {
		transformEnvironment(\.handledEvents) { $0.append(event) }
	}
	
	func registerHandler(for error: any Error.Type) -> some View {
		transformEnvironment(\.handledErrors) { $0.append(error) }
	}
}
