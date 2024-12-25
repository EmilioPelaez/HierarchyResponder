
# Understanding Responders

Using responders to receive or handle events and errors.

## What are responders?

Responders are closures that "respond" in different ways to events or errors being triggered or reported by a view down in the view hierarchy.

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

## Registering Responders

Registering a responder is done using the modifier syntax, and just like with any other modifier in SwiftUI, the order in which they are executed **matters**.

In simple terms, responders will be called in the order they added to the view, which is inverse to their position in the view hierarchy.

For a better understanding of the view hierarchy you can read [this article](https://betterprogramming.pub/building-a-responder-chain-using-the-swiftui-view-hierarchy-2a08df23689c).

```swift
struct ContentView: View {
  var body: some View {
    TriggerView()
      .handleEvent(MyEvent.self) {
      //  Will be called first and absorb `MyEvent` objects
      }
      .handleEvent {
      //  Will be called second, will not receive any `MyEvent` objects
      }
  }
}
```

## Different Kinds of Responders

There's several kinds of responders, and each responder has two versions, one that will respond to any kind of event or error, and one that receives the type of an event or error as the first parameter and will only act on values of that type.

It is recommended to use explicit responders, aka responders that specify the type of the event or error they will receive. Doing this in combination with the safety modifiers will perform runtime checks and warn you when an event or error doesn't have an associated responder. 

### Receiving an Event or Error

When registering a receive responder, the handling closure will determine if the event or error was handled or not.

If the event or error was handled, the closure should return `.handled`, otherwise it should return `.unhandled`.

Unhandled events will continue to be propagated up the view hierarchy.

```swift
struct ContentView: View {
  var body: some View {
    TriggerView()
      .receiveEvent { event in
        if canHandle(event) {
          //  Do something
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

```swift
struct ContentView: View {
  var body: some View {
    TriggerView()
      .transformEvent(MyEvent.self) {
        return AnotherEvent()
      }
  }
}
```

### Failable Responders

All event responders, as well as the `catchError` responders, receive a throwing closure. Any errors thrown inside this closure will be propagated up the view hierarchy as if it had been reported using the `reportError` closure.

```swift
struct ContentView: View {
  var body: some View {
    TriggerView()
      .handleEvent { event in
        guard canHandle(event) else {
          throw AnError()
        }
        //  Handle Event
      }
  }
}
```

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

## Topics

### Receiving Events and Errors

- ``SwiftUICore/View/receiveEvent(_:)``
- ``SwiftUICore/View/receiveEvent(_:closure:)-6l11u``
- ``SwiftUICore/View/receiveError(_:)``
- ``SwiftUICore/View/receiveError(_:closure:)-9lqgx``

### Handling Events and Errors

- ````
- ``SwiftUICore/View/handleEvent(_:)``
- ``SwiftUICore/View/handleEvent(_:handler:)-2lm98``
- ``SwiftUICore/View/handleError(_:)``
- ``SwiftUICore/View/handleError(_:handler:)-3n403``

### Transforming Events and Errors

- ``SwiftUICore/View/transformEvent(_:)``
- ``SwiftUICore/View/transformEvent(_:transform:)-8qt1d``
- ``SwiftUICore/View/transformError(_:)``
- ``SwiftUICore/View/transformError(_:transform:)-22chc``

### Recovering from Errors

- ``SwiftUICore/View/catchError(_:)``
- ``SwiftUICore/View/catchError(_:handler:)-8s21e``
