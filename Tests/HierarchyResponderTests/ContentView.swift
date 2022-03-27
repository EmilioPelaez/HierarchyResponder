//
//  ContentView.swift
//  HierarchyResponderTests
//
//  Created by Emilio Peláez on 26/03/22.
//

import SwiftUI

struct FirstEvent: Event {}
struct SecondEvent: Event {}
struct ThirdEvent: Event {}
struct FourthEvent: Event {}
struct FifthEvent: Event {}
struct SixthEvent: Event {}
struct SeventhEvent: Event {}
struct EigthEvent: Event {}
struct NinthEvent: Event {}
struct TenthEvent: Event {}
struct EleventhEvent: Event {}
struct MyError: Error {}

struct FirstError: Error {}
struct SecondError: Error {}
struct ThirdError: Error {}
struct FourthError: Error {}
struct FifthError: AlertableError {
	var message: String { "Error Test 3" }
}
struct SixthError: Error {}
struct SeventhError: Error {}
struct EightError: Error {}

struct ContentView: View {
	@State var alertTitle = ""
	@State var handled = false
	
	var body: some View {
		VStack {
			eventBody0
			eventBody1
			eventBody2
			errorBody0
			errorBody1
		}
		.alert(alertTitle, isPresented: $handled) {
			Button("Close") {
				handled = false
			}
		}
	}
	
	var eventBody0: some View {
		EventTriggerView0()
	}
	
	@ViewBuilder
	var eventBody1: some View {
		//	Non-Failable Modifiers
		EventTriggerView1()
			.receiveEvent { _ in .notHandled }
			.transformEvent(FirstEvent.self) { SecondEvent() }
			.receiveEvent(SecondEvent.self) { .notHandled }
			.handleEvent(SecondEvent.self) {
				alertTitle = "Event Test 1"
				handled = true
			}
			.transformEvent { _ in FourthEvent() }
			.handleEvent { _ in
				alertTitle = "Event Test 2"
				handled = true
			}
	}
	
	@ViewBuilder
	var eventBody2: some View {
		//	Failable Modifiers
		EventTriggerView2()
			.receiveEvent { _ in try failable(.notHandled) }
			.transformEvent(FifthEvent.self) { try failable(SixthEvent()) }
			.receiveEvent(SixthEvent.self) { try failable(.notHandled) }
			.handleEvent(SixthEvent.self) {
				alertTitle = "Event Test 4"
				handled = true
				try failable(())
			}
			.handleEvent(NinthEvent.self) { throw MyError() }
			.transformEvent { _ in try failable(EigthEvent()) }
			.handleEvent { _ in
				alertTitle = "Event Test 5"
				handled = true
				try failable(())
			}
			.handleError(MyError.self) {
				alertTitle = "Event Test 6"
				handled = true
			}
	}
	
	var errorBody0: some View {
		ErrorTriggerView0()
			.receiveError { _ in .notHandled }
			.receiveError(SixthError.self) { _ in .handled }
			.transformError(FirstError.self) { SecondError() }
			.receiveError(SecondError.self) { .notHandled }
			.handleError(SecondError.self) {
				alertTitle = "Error Test 1"
				handled = true
			}
			.handleAlertErrors()
			.transformError { _ in FourthError() }
			.handleError { _ in
				alertTitle = "Error Test 2"
				handled = true
			}
	}
	
	var errorBody1: some View {
		ErrorTriggerView1()
			.catchError(SeventhError.self) {
				TenthEvent()
			}
			.handleEvent(TenthEvent.self) {
				alertTitle = "Error Test 5"
				handled = true
			}
			.catchError { _ in
				EleventhEvent()
			}
			.handleEvent(EleventhEvent.self) {
				alertTitle = "Error Test 6"
				handled = true
			}
	}
	
	@discardableResult
	func failable<T>(_ value: T) throws -> T {
		value
	}
}

struct EventTriggerView0: View {
	@Environment(\.triggerEvent) var triggerEvent

	var body: some View {
		EventButton(FirstEvent()) { Text("Event Test 0") }
	}
}

struct EventTriggerView1: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	var body: some View {
		VStack {
			EventButton(FirstEvent()) {
				Text("Event Test 1")
			}
			EventButton("Event Test 2", event: ThirdEvent())
		}
	}
}

struct EventTriggerView2: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	var body: some View {
		VStack {
			EventButton(FifthEvent()) {
				Text("Event Test 4")
			}
			EventButton("Event Test 5", event: SeventhEvent())
			EventButton("Event Test 6" as LocalizedStringKey, event: NinthEvent())
		}
	}
}

struct ErrorTriggerView0: View {
	@Environment(\.reportError) var reportError
	
	var body: some View {
		Button("Error Test 1") {
			reportError(FirstError())
		}
		Button("Error Test 2") {
			reportError(ThirdError())
		}
		Button("Error Test 3") {
			reportError(FifthError())
		}
		Button("Error Test 4") {
			reportError(SixthError())
		}
	}
}

struct ErrorTriggerView1: View {
	@Environment(\.reportError) var reportError
	
	var body: some View {
		Button("Error Test 5") {
			reportError(SeventhError())
		}
		Button("Error Test 6") {
			reportError(EightError())
		}
	}
}
