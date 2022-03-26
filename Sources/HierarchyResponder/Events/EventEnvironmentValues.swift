//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

public extension EnvironmentValues {
	/**
	 This closure can be used when an `Event` that can't be handled by the
	 current view is generated. The `Event` will be sent up the view hierarchy
	 until it is handled by another view.
	 
	 Views can register a closure to handle these `Events` using the
	 `receiveEvent` and `handleEvent` view modifiers.
	 
	 If no view has registered an event that handles the `Event`, an
	 `assertionFailure` will be triggered.
	 */
	var triggerEvent: (Event) -> Void {
		{ eventClosure($0) }
	}
}
