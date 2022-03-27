# Hierarchy Responder

[![tests](https://github.com/EmilioPelaez/HierarchyResponder/actions/workflows/tests.yml/badge.svg)](https://github.com/EmilioPelaez/HierarchyResponder/actions/workflows/tests.yml)
[![codecov](https://codecov.io/gh/EmilioPelaez/HierarchyResponder/branch/main/graph/badge.svg?token=05Y9RYF45B)](https://codecov.io/gh/EmilioPelaez/HierarchyResponder)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20macOS%20|%20tvOS%20%20|%20watchOS-lightgray.svg)]()
[![Swift 5.6](https://img.shields.io/badge/swift-5.6-orange.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)
[![Twitter](https://img.shields.io/badge/twitter-@emiliopelaez-blue.svg)](http://twitter.com/emiliopelaez)

`HierarchyResponder` is a framework designed to use the SwiftUI view hierarchy as a responder chain for event and error handling handling. By using the view hierarchy to report errors and trigger events, views can become more indepentent without sacrificing communication with other views.

To report an error or trigger an event, a view reads a closure from the environment, and calls that closure with the event or error as a parameter.

Views above in the view hierarchy can register different responders that will be executed with the event or error as a parameter.

A more detailed explanation can be found in [this article](https://betterprogramming.pub/building-a-responder-chain-using-the-swiftui-view-hierarchy-2a08df23689c).

## Event Protocol

`Event` is requirement-less protocol that identifies a type as an event that can be sent up the SwiftUI view hierarchy.

It can be of any type and contain any kind of additional information. It exists to avoid annotating the types used by methods in this framework as `Any`.

## Triggering an Event

Events are triggered using the `triggerEvent` closure that can be read from the `Environment`.

```swift
struct MyEvent: Event {}

struct TriggerView: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	var body: some View {
		Button("Trigger") {
			triggerEvent(MyEvent())
		}
	}
}
```

## Reporting an Error

In a similar way to events, errors are triggered using the `reportError` closure.

```swift
struct MyError: Error {}

struct TriggerView: View {
	@Environment(\.reportError) var reportError
	
	var body: some View {
		Button("Trigger") {
			reportError(MyError())
		}
	}
}
```

## Registering Responders

Registering a responder is done using the modifier syntax. There's several kinds of responders, and each responder has two versions, one that will respond to any kind of event or error, and one that receives the type of an event or error as the first parameter and will only act on values of that type.

```swift
struct ContentView: View {
	var body: some View {
		TriggerView()
			.handleEvent(MyEvent.self) {
			//	Only events of the type MyEvent will be handled
			}
			.handleEvent {
			//	All event types will be handled here
			}
	}
}
```

### Receiving an Event or Error

When registering a receive responder, the handling closure can determine if the event or error was handled or not.

If the event or error was handled, the closure should return `.handled`, otherwise it should return `.unhandled`.

Unhandled events will continue to be propagated up the view hierarchy.

```swift
struct ContentView: View {
	var body: some View {
		TriggerView()
			.receiveEvent { event in
				if canHandle(event) {
					//	Do something
					return .handled
				}
				return .notHandled
			}
	}
}
```

### Handling an Event or Error

Handle responders will consume the event or error they receive, which will stop it from propagating up the view hierarchy. This is equivalent to using a `receiveEvent` closure that always returns `.handled`.


### Transforming an Event or Error

Transforming functions can be used to replace the received value with another.

### Catching Errors

Catching responders allow you to receive an error and convert it into an event that will be propagated instead.

```swift
struct UnauthenticatedError: Error {}
struct ShowSignInEvent: Event {}

struct ContentView: View {
	var body: some View {
		TriggerView()
			.catchError(UnauthenticatedError.self) {
				ShowSignInEvent()
			}
	}
}
```

### Failable Responders

All event responders, as well as the catchError responders, receive a throwing closure. Any errors thrown inside this closure will be propagated up the view hierarchy as if it had been reported using the `reportError` closure.

```swift
struct ContentView: View {
	var body: some View {
		TriggerView()
			.handleEvent { event in
				guard canHandle(event) else {
					throw AnError()
				}
				//	Handle Event
			}
	}
}
```

### Order Matters!

Just like with any other modifiers in SwiftUI, the order in which responders are added to a view matters, the closer they are to the view they modify.

Basically, responders will be called in the order they added to the view.

```swift
struct ContentView: View {
	var body: some View {
		TriggerView()
			.handleEvent(MyEvent.self) {
			//	Will be called first
			}
			.handleEvent {
			//	Will be called second
			}
	}
}
```

For a better understanding of the view hierarchy you can read [this article](https://betterprogramming.pub/building-a-responder-chain-using-the-swiftui-view-hierarchy-2a08df23689c).
