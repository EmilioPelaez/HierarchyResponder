# Goodies

Small utilities to make things easier.

## EventButton

`EventButton` is essentially a wrapper for `Button` that receives, instead of an action closure, an `Event` that is triggered whenever the underlying Button's action would be called.

```swift
// Before:
Button("Tap Me") {
  //  Perform action
}

// After:
EventButton("Tap Me", event: MyEvent())
```

## onTapGesture(trigger:)

The `onTapGesture(trigger:)` modifier works just like `onTapGesture(perform:)`, but instead of executing a closure it triggers an event.

## AlertableErrors

`AlertableError` is a protocol that conforms to Error and represents a user-friendly error with a message and an optional title.

By using the `.handleAlertErrors()` modifier, errors that conform to the `AlertableError` protocol will be handled by displaying an alert with the title and message provided by the error.

## Topics

- ``EventButton``
- ``SwiftUICore/View/onTapGesture(count:trigger:)``
- ``AlertableError``
- ``SwiftUICore/View/handleAlertErrors()``
