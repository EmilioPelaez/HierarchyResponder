# ``HierarchyResponder``

Use the SwiftUI View Hierarchy as a responder chain

![Image Banner](SocialImage.png)

`HierarchyResponder` is a framework that allows you to use the SwiftUI view hierarchy as a responder chain for event and error handling. By using the view hierarchy to report errors and trigger events, views can become more indepentent without sacrificing communication with other views.

To report an error or trigger an event, a view reads a closure from the environment, and calls that closure with the event or error as a parameter.

Views above in the view hierarchy can register different responders that will be executed with the event or error as a parameter.

```swift
struct ItemSelectionEvent: Event {
  let item: Item
}

struct ParentView: View {
  @State var selection: Item?
  let items: [Item] = ...
  
  var body: some View {
    GridView(items: items)
      // The handleEvent modifier registers a responder closure to be executed when
      // an ItemSelectionEvent is triggered in any descendant view
      .handleEvent(ItemSelectionEvent.self) { event in
        selection = event.item
      }
      .sheet(item: selection) { ItemDetail($0) }
  }
}

struct GridView: View {
  let items: [Item]
  
  var body: some View {
    ForEach(items) { item in
      ItemView(item: item)
    }
  }
}

struct ItemView: View {
  @Environment(\.triggerEvent) var triggerEvent
  let item: Item
  
  var body: some View {
    ItemPreview(item)
      .onTapGesture {
        // The triggerEvent object, called as a closure, triggers an event which
        // will be received by any ancestor views that registered a responder
        triggerEvent(ItemSelectionEvent(item: item))
      }
  }
}
```

@Links(visualStyle: detailedGrid) {
	- <doc:GettingStarted>
	- <doc:UnderstandingResponders>
	- <doc:PublishedEvents>
	- <doc:Goodies>
	- <doc:Safety>
}
