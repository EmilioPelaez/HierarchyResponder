# Safety

Best practices to avoid unhandled events and errors

A trade-off of the flexibility offered by this pattern is that it can be easy to lose track of where events are generated and handled. A few modifiers are included to mitigate this.

The `.triggers` and `.reports` modifiers can be used by views that contain complex hierarchies (like a screen view) to expose a kind of "API" to any views that utilize it.

```swift
struct FeedView: View {
  var body: some View {
    FeedList()
      .triggers(ShowPostEvent.self, ShowProfileEvent.self)
      .reports(AuthenticationError.self)
  }
}
```

These modifiers are not only useful for the developer consuming the `FeedView` object, they also act as a runtime check that will raise a warning if an event or error that is not on the list is utilized, and when explicit responders are required (enabled by default) it will raise a warning if there are no responders for these specific events and errors above in the hierarchy.

The `.responderSafetyLevel` and `.requireExplicitResponders` modifiers allow customization of the behavior of the safety checks. The default responder safety level will throw console warnings, the strict safety level will trigger a `fatalError`, and the disabled safety level will ignore any infractions. All of these checks are disabled on release builds, to avoid causing crashes for users.
