//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

/**
 This object, which can be used as a closure, can be used when an `Event`
 that can't be handled by the current view is generated. The `Event` will be
 sent up the view hierarchy until it is handled by another view.
 
 Views can register a closure to handle these `Events` using the
 `receiveEvent` and `handleEvent` view modifiers, among others.
 
 If no view has registered an event that handles the `Event`, an
 `assertionFailure` will be triggered unless the view is being previewed.
*/
public struct TriggerEvent {
	let function: (Event) -> Void
	
	public func callAsFunction(_ event: Event) -> Void {
		function(event)
	}
}

public extension EnvironmentValues {
	/**
	 This object, which can be used as a closure, can be used when an `Event`
	 that can't be handled by the current view is generated. The `Event` will be
	 sent up the view hierarchy until it is handled by another view.
	 
	 Views can register a closure to handle these `Events` using the
	 `receiveEvent` and `handleEvent` view modifiers, among others.
	 
	 If no view has registered an event that handles the `Event`, an
	 `assertionFailure` will be triggered unless the view is being previewed.
	 */
	var triggerEvent: TriggerEvent {
		get { self[EventClosureEnvironmentKey.self] }
		set { self[EventClosureEnvironmentKey.self] = newValue }
	}
}
