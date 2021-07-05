# ColorPicker

A bar item that provides a system-defined color picker.

## Example

```swift
@objc dynamic var pickerColor: NSColor = .white
  …
DSFTouchBar.ColorPicker(DSFTouchBar.LeafIdentifier("character-color-selector"))
   .customizationLabel("Character Color")
   .showAlpha(true)
   .bindSelectedColor(to: self, withKeyPath: #keyPath(pickerColor))
```
[Sample Code](../Demos/DSFTouchBar%20Demo/DSFTouchBar%20Demo/views/demo/ColorViewController.swift)

## Properties

| Property   | Type (default)     |  Description |
|----------|-------------|------|
| `showAlpha`  | `Bool`    | Should the color picker allow changing alpha? |


## Actions

| Method              | Type                 | Description                       |
|:--------------------|:---------------------|:----------------------------------|
| `action`            | `(NSColor) -> Void`  | A block which gets called when the user selects a color |

## Bindings

| Method               | Type           | Description                                                     |
|:---------------------|:---------------|:----------------------------------------------------------------|
| `bindSelectedColor`  | `NSColor`      | Create a two-way binding for the color to the specified keyPath |
| `bindIsEnabled`      | `Bool`         | Bind the enabled state to a keypath |
