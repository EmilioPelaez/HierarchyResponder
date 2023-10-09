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
	
	func triggers(_ events: any Event.Type...) -> some View {
#if DEBUG
		modifier(EventSafetyModifier(events: events))
#else
		self
#endif
	}
	
	func reports(_ errors: any Error.Type...) -> some View {
#if DEBUG
		modifier(ErrorSafetyModifier(errors: errors))
#else
		self
#endif
	}
	
	func responderSafetyLevel(_ level: ResponderSafetyLevel) -> some View {
		environment(\.responderSafetyLevel, level)
	}
	
}
