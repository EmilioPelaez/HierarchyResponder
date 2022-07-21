//
//  Created by Emilio Peláez on 26/03/22.
//

import SwiftUI

struct ErrorClosureEnvironmentKey: EnvironmentKey {
	static var defaultValue: (Error) -> Void = { error in
		assertionFailure("Unhandled Error \(error)")
	}
}

struct EventClosureEnvironmentKey: EnvironmentKey {
	static var defaultValue: TriggerEvent = .init { _ in }
}

extension EnvironmentValues {
	var errorClosure: (Error) -> Void {
		get { self[ErrorClosureEnvironmentKey.self] }
		set { self[ErrorClosureEnvironmentKey.self] = newValue }
	}
}
