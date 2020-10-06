# ColorPicker

A touchbar color picker

## Example

```swift
DSFTouchBar.ColorPicker("color-picker")
   .bindSelectedColor(to: self, withKeyPath: #keyPath(selectedColor))
```
[Sample Code](../Demos/DSFTouchBar%20Demo/DSFTouchBar%20Demo/views/demo/ColorViewController.swift)

## Properties

[Core properties](core.md)

| Property   | Type (default)     |  Description |
|----------|-------------|------|
| `showAlpha`  | `Bool`    | Should the color picker allow changing alpha? |


## Actions

[Core actions](core.md)

| Action    | Description |
|-----------|---------------------|
| `action`  | The block to call when the toolbar item is activated (eg. clicked)  |

## Bindings

[Core bindings](core.md)

| Binding   | Type (default)     |  Description |
|----------|-------------|-------------|
| `bindSelectedColor` | `NSColor` | Bind the selected color to a key path
