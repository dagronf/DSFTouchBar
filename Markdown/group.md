# Group

A group groups a number of toolbar items together into a single unit.  These items appear as a single group within the customization panel

## Example

```swift
DSFTouchBar.Group("group", customizationLabel: "Smile Icons") {
   DSFTouchBar.Text("heart").label("😀💝")
   DSFTouchBar.Text("hat-bow").label("😀👒")
   DSFTouchBar.Text("koala").label("😀🐨")
}
```

## Properties

| Property   | Type (default)     |  Description |
|----------|-------------|------|
| `equalWidths`  | `Bool` | Make all group items the same width

