# ScrollingGroup

A group groups a number of toolbar items together into a single unit and allows horizontal scrolling between these items.  These items appear as a single group within the customization panel

## Example

```swift
DSFTouchBar.ScrollGroup("scrollgroup", customizationLabel: "Button Scroller") {
   DSFTouchBar.Button("button-1")
      .title("The First Button")
      .action { _ in Swift.print("1 pressed")
   }
   DSFTouchBar.Button("button-2")
      .title("The Second Button")
      .action { _ in Swift.print("2 pressed")
   }
   DSFTouchBar.Button("button-3")
      .title("The Third Button")
      .action { _ in Swift.print("3 pressed")
   }
   DSFTouchBar.Button("button-4")
      .title("The Fourth Button")
      .action { _ in Swift.print("4 pressed")
   }
}
```
[Sample Code](../Demos/DSFTouchBar%20Demo/DSFTouchBar%20Demo/views/demo/ScrollGroupViewController.swift)

