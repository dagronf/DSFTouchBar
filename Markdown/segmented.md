# Segmented

A touchbar item representing a segmented control.

## Example

```swift
@objc dynamic var selectedSegments = NSIndexSet()
  …
DSFTouchBar.Segmented(NSTouchBarItem.Identifier("com.superblah.Segmented"), trackingMode: .selectAny)
   .add(label: "one")
   .add(label: "two")
   .add(label: "three")
   .bindSelectionIndexes(to: self, withKeyPath: #keyPath(selectedSegments)),
```

[Sample Code](../Demos/DSFTouchBar%20Demo/DSFTouchBar%20Demo/views/demo/SegmentedControlViewController.swift)

## Adding items

| Action   | Type (default)     |  Description |
|:---------|:-------------------|:----------------------------------|
| `add`    | `String`/`NSImage` | Add a new segment containing a String, NSImage, or both |

## Actions

| Action   | Type (default)     |  Description |
|:-----------------|:---------------------|:----------------------------------|
| `action`          | `(Set<Int>) -> Void` | Called when the selection state of the control changes |

## Properties

| Property   | Type (default)     |  Description |
|:--------------------|:---------------------|:----------------------------------|
| `selectedColor`| `NSColor`           | The background color for selected segments |
| `selectedIndexes` | `Set<Int>` | Set the initial selected segments |
| `customizationLabel`| `String`           | The label to display when customizing the touch bar |

## Bindings

| Method               | Type           | Description                                                     |
|:---------------------|:---------------|:----------------------------------------------------------------|
| `bindSelection` | `Set<Int>` | Create a two-way binding for the selection state to the specified `keyPath` |
| `bindIsEnabled` | `Bool`                 | Bind the enabled state to a keypath |
| `bindIsHidden`  | `Bool`                 | Bind the hidden state to a keypath  |
