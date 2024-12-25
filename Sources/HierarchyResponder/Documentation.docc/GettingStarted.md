# Getting Started

The basics to understand how to use the hierarchy responder pattern.

## The Event Protocol

`Event` is a requirement-less protocol that identifies a type as an event that can be sent up the SwiftUI view hierarchy.

It can be of any type and contain any kind of additional information. It exists to be able to easily identify a type as an object, and to avoid having to annotate the types used by methods in this framework as `Any`.

## Triggering an Event

Events are triggered using the `triggerEvent` object that can be read from the `Environment`. Since this object implements `callAsFunction`, it can be called like closure.

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

In a similar way to events, errors are triggered using the `reportError` closure. Since this object implements `callAsFunction`, it can be called like closure.

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

## Handling an Event

Events and Errors are handled using one of the multiple responders. The `.handleEvent` responder below, for example, receives only events of the type `MyEvent`.

```swift
struct ContentView: View {
  var body: some View {
    TriggerView()
      .handleEvent(MyEvent.self) { event in
        //  Do something with event
      }
  }
}
```

@Links(visualStyle: detailedGrid) {
	- <doc:UnderstandingResponders>
}

## Topics

