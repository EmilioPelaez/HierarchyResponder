//
//  ContentView.swift
//  HierarchyWatch Watch App
//
//  Created by Emilio Peláez on 14/9/23.
//

import SwiftUI

import HierarchyResponder
import SwiftUI

// A simple event that could be triggered by a user action or another event
struct ButtonEvent: Event {}
// An error that can be displayed in an alert
struct ButtonError: AlertableError {
	var title: String? { "Hello" }
	var message: String { "World!" }
}

struct ContentView: View {
	var body: some View {
		TriggerView()
		/*
		`handleEvent` will trigger the closure for all events of the type
		`ButtonEvent`. In this example we'll simply throw an error
		 */
			.handleEvent(ButtonEvent.self) {
				throw ButtonError()
			}
		/*
		`handleAlertErrors` will handle all errors that conform to `AlertableError`
		and will display an alert
		 */
			.handleAlertErrors()
	}
}

struct TriggerView: View {
	var body: some View {
		/*
		Instead of using `Button`, we use `EventButton`, which automatically sends
		a `ButtonEvent` event up the view hierarchy
		 */
		EventButton(ButtonEvent()) {
			Text("Tap Me!")
				.padding(.horizontal)
				.font(.title)
		}
		.buttonStyle(.borderedProminent)
		.tint(.blue)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
