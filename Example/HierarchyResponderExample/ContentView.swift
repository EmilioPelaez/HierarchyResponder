//
//  ContentView.swift
//  HierarchyResponderExample
//
//  Created by Emilio Peláez on 26/03/22.
//

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
	@State var identifier: Date = .now
	@State var value: Int = 0
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	var body: some View {
		VStack {
			TriggerView()
			Text("\(value)")
		}
		/*
		`handleEvent` will trigger the closure for all events of the type
		`ButtonEvent`. In this example we'll simply throw an error
		 */
			.handleEvent(ButtonEvent.self) {
				try await Task.sleep(nanoseconds: 5_000_000_000)
				print("Hello World")
				value += 1
			}
		/*
		`handleAlertErrors` will handle all errors that conform to `AlertableError`
		and will display an alert
		 */
			.handleAlertErrors()
			.id(identifier)
			.onReceive(timer) { input in
				identifier = input
			}
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
