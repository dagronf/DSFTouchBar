# Button

A touchbar item representing a button.

## Example

```swift
@objc dynamic var pressedState: NSControl.StateValue = .off
  …
DSFTouchBar.Button(DSFTouchBar.LeafIdentifier("button-demo"),
                   customizationLabel: "State-bound button")
   .title("OFF")
   .alternateTitle("ON")
   .backgroundColor(.red)
   .bindState(to: self, withKeyPath: #keyPath(pressedState))
   .action { state in
      Swift.print("Button state changed to \(state)")
   }
```

[Sample Code](../Demos/DSFTouchBar%20Demo/DSFTouchBar%20Demo/views/demo/ButtonsViewController.swift)

## Properties

| Property   | Type (default)     |  Description |
|----------|-------------|------|
| `buttonType` | `NSButton.ButtonType` | The type of button (eg. on/off, toggle, momentary etc |
| `bezelStyle`  | `NSButton.BezelStyle` | The style of the button |
| `width`  | `CGFloat` | A fixed width for the button |
| `title`  | `String`    | The title of the button |
| `alternateTitle` | `String` | The title that the button displays when the button is in an on state |
| `attributedTitle` | `NSAttributedString` | The attributed text displayed on the button                         |
| `attributedAlternateTitle` | `NSAttributedString` | The title that is displayed when the button is on (for on/off types |
| `state` | `NSControl.StateValue` | The initial state for the control
| `image`  | `NSImage`    | The image to display on the button |
| `imagePosition`  | `NSControl.ImagePosition`    | The position of the image on the button (eg. left, right etc) |
| `imageScaling`  | `NSImageScaling`    | How the image is scaled when presenting the image on the button |
| `foregroundColor` | `NSColor` | The text color for the button
| `backgroundColor` | `NSColor` | The background color for the button

## Actions

| Method            | Type                 | Description                       |
|:------------------|:---------------------|:----------------------------------|
| `action` | `(NSControl.StateValue) -> Void` | A block which gets called when the user interacts with the button |

## Bindings

| Method                | Type                   | Description         |
|:----------------------|:-----------------------|:------------------------------------------------|
| `bindTitle`           | `String`               | Bind the button's title to a key path |
| `bindState`           | `NSControl.StateValue` | Create a two-way state binding to the specified keyPath |
| `bindBackgroundColor` | `NSColor`              | Bind the background color to a key path
| `bindIsEnabled`       | `Bool`                 | Bind the enabled state to a keypath |
| `bindIsHidden`        | `Bool`                 | Bind the hidden state to a keypath |

