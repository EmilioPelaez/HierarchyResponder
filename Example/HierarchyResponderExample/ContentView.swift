//
//  ContentView.swift
//  HierarchyResponderExample
//
//  Created by Emilio Peláez on 26/03/22.
//

import HierarchyResponder
import SwiftUI

struct EventOne: Event {}
struct EventTwo: Event {}

struct ContentView: View {
	@State var value: Int = 0
	
	var body: some View {
		EventButton("Event 1", event: EventOne())
			.triggers(EventOne.self)
			.triggers(EventTwo.self)
			.handleEvent(EventOne.self) {
				print("Handled 1")
			}
			.handleEvent(EventTwo.self) {
				print("Handled 2")
			}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
