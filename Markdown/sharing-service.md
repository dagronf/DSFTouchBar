# SharingService

Display a button which can be used to share data via a share sheet.

## Example

```swift
@objc dynamic var sharingAvailable = false
var selectedText = "some text"
...
DSFTouchBar.SharingServicePicker("sharey", title: "Share")
   .bindIsEnabled(to: self, withKeyPath: \MyViewController.sharingAvailable)
   .provideItems { [weak self] in
      guard let `self` = self else { return [] }
      return [self.selectedText]
   }
```

[Sample Code](../Demos/DSFTouchBar%20Demo/DSFTouchBar%20Demo/views/demo/SharingViewController.swift)


## Properties

[Core propertes](core.md)

| Property   | Type (default)     |  Description |
|----------|-------------|------|
| `title` | `String` | The title used for the share button
| `image`  | `NSImage`  | The image to use on the button |

## Actions

[Core actions](core.md)

| Action    | Description |
|-----------|---------------------|
| `provideItems`  | This block is called when the button is pressed to retrieve the array of items that are to be shared |

## Bindings

[Core bindings](core.md)

| Binding   | Type (default)     |  Description |
|----------|-------------|------|
| `bindIsEnabled` | `Bool` | Bind the enabled state of the share button to a key path

