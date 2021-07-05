# Slider

A bar item that provides a slider control for choosing a value in a range.

See [Apple's documentation](https://developer.apple.com/documentation/appkit/nsslidertouchbaritem)

## Example

```swift
@objc dynamic var sliderValue: CGFloat = 0.75 {
  …
DSFTouchBar.Slider(identifier: "squish", min: 0.0, max: 1.0)
   .label("Slider")
   .minimumValueAccessory(image: NSImage(named: NSImage.touchBarAudioOutputVolumeOffTemplateName))
   .maximumValueAccessory(image: NSImage(named: NSImage.touchBarAudioOutputVolumeHighTemplateName))
   .bindValue(to: self, withKeyPath: #keyPath(sliderValue))
   .action { value in
      //Swift.print("\(value)")
   }
```
[Sample Code](../Demos/DSFTouchBar%20Demo/DSFTouchBar%20Demo/views/demo/SliderViewController.swift)

## Properties
	
| Property   | Type (default)     |  Description |
|----------|-------------|------|
| `value`  | `CGFloat`  | The initial value for the slider, or called to update the slider value if needed |
| `label`  | `String?`  | The label associated with the slider |
| `minimumValueAccessory` | `NSImage` | The accessory that appears at the end of the slider with the minimum value |
| `maximumValueAccessory` | `NSImage` | The accessory that appears on the end of the slider with the maximum value |

## Actions

[Core actions](core.md)

| Action    | Description |
|-----------|---------------------|
| `action`  | The block to call when the slider is dragged or the value changes |
| `enabled` | Supply a callback block to be called to determine the enabled state of the item |

## Bindings

[Core bindings](core.md)

| Binding          | Type      |  Description        |
|------------------|-----------|---------------------|
| `bindValue`      | `CGFloat` | Bind the enabled state of the share button to a key path |
| `bindIsEnabled`  | `Bool`    | Bind the enabled state to a keypath |

