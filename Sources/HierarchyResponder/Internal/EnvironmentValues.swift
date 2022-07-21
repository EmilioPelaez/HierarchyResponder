//
//  Created by Emilio Peláez on 26/03/22.
//

import SwiftUI

struct ErrorClosureEnvironmentKey: EnvironmentKey {
	static var defaultValue: ReportError = .init { error in
		assertionFailure("Unhandled Error \(error)")
	}
}

struct EventClosureEnvironmentKey: EnvironmentKey {
	static var defaultValue: TriggerEvent = .init { _ in }
}
