# Label

A touchbar item representing a text label.

## Example

```swift
@objc dynamic var userName: String = "Name"
  …
DSFTouchBar.Text(DSFTouchBar.LeafIdentifier("userid"), label: "Id")
DSFTouchBar.Text(DSFTouchBar.LeafIdentifier("username"))
   .bindLabel(to: self, withKeyPath: #keyPath(userName))
DSFTouchBar.Text(DSFTouchBar.LeafIdentifier("usercity"))
   .label("City")
```

[Sample Code](../Demos/DSFTouchBar%20Demo/DSFTouchBar%20Demo/views/demo/TextViewController.swift)

## Properties

| Property   | Type (default)     |  Description |
|:--------------------|:---------------------|:----------------------------------|
| `label`             | `String`             | The plain text displayed          |
| `attributedLabel`   | `NSAttributedString` | The attributed text displayed     |
| `customizationLabel`| `String`             | The label to display when customizing the touch bar |

## Bindings

| Method                | Type                   | Description                                 |
|:----------------------|:-----------------------|:--------------------------------------------|
| `bindLabel`           | `String`   | Create a binding for the label to the specified keyPath |
| `bindAttributedLabel` | `NSAttributedString`   | Create a binding for the attributedString to the specified keyPath |

