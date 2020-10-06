# Button

A touchbar item representing a button.

## Example

```swift
DSFTouchBar.Button("button-demo", customizationLabel: "State-bound button")
   .title("OFF")
   .alternateTitle("ON")
   .backgroundColor(.red)
   .bindState(to: self, withKeyPath: #keyPath(button2State))
   .action { state in
      debugPrint("Button state changed to \(state)")
   }
```

[Sample Code](../Demos/DSFTouchBar%20Demo/DSFTouchBar%20Demo/views/demo/ButtonsViewController.swift)

## Properties

[Core properties](core.md)

| Property   | Type (default)     |  Description |
|----------|-------------|------|
| `buttonType` | `NSButton.ButtonType` | The type of button (eg. on/off, toggle, momentary etc |
| `bezelStyle`  | `NSButton.BezelStyle` | The style of the button |
| `width`  | `CGFloat` | The fixed width for the button |
| `title`  | `String`    | The title of the button |
| `alternateTitle` | `String` | The title that the button displays when the button is in an on state |
| `state` | `NSControl.StateValue` | The initial state for the control
| `image`  | `NSImage`    | The image to display on the button |
| `imagePosition`  | `NSControl.ImagePosition`    | The position of the image on the button (eg. left, right etc) |
| `imageScaling`  | `NSImageScaling`    | How the image is scaled when presenting the image on the button |
| `foregroundColor` | `NSColor` | The text color for the button
| `backgroundColor` | `NSColor` | The background color for the button

## Actions

[Core actions](core.md)

| Action    | Description |
|-----------|---------------------|
| `action`  | The block to call when the button is activated (eg. clicked)  |

## Bindings

[Core bindings](core.md)

| Binding   | Type (default)     |  Description |
|----------|-------------|-------------|
| `bindTitle` | `String` | Bind the button's title to a key path
| `bindState` | `NSControl.StateValue ` | Bind the buttons state to a key path
| `bindBackgroundColor` | `NSColor` | Bind the background color to a key path
