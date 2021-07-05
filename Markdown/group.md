# Group

A group groups a number of toolbar items together into a single unit. These items appear as a single group within the customization panel

## Example

```swift
DSFTouchBar.Group("base-popover", equalWidths: false) { 
   DSFTouchBar.Button("tweak-button")
      ...
   DSFTouchBar.Slider("slider", min: 0.0, max: 100.0)
      ...
   DSFTouchBar.Button("reset-button")
      ...
)
```

## Properties

| Property      | Type (default)     |  Description |
|---------------|--------|-------------------------------------|
| `equalWidths` | `Bool` | Make all group items the same width |

