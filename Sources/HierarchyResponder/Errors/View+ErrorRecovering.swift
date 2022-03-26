//
//  View+ErrorRecovering.swift
//  ErrorHierarchyTests
//
//  Created by Emilio Peláez on 24/02/22.
//

import SwiftUI

public extension View {
	
	/**
	 Registers a closure to receive all `Errors` triggered using the
	 `triggerError` Environment closure, and turn them into an Event that will
	 be propagated instead.
	 
	 An error thrown by the handler closure will be propagated up the hierarchy.
	 */
	func catchError(_ handler: @escaping (Error) throws -> Event) -> some View {
		let handlerModifier = ErrorHandlerViewModifier {
			try handler($0)
		}
		return modifier(handlerModifier)
	}
	
	/**
	 Registers a closure to receive errors of the supplied type triggered using the
	 `triggerError` Environment closure, and turn them into an Event that will
	 be propagated instead.
	 
	 An error thrown by the handler closure will be propagated up the hierarchy.
	 */
	func catchError<E: Error>(_ type: E.Type, handler: @escaping (E) throws -> Event) -> some View {
		catchError {
			guard let error = $0 as? E else {
				throw $0
			}
			return try handler(error)
		}
	}
	
}
