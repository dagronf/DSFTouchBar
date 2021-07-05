# View

A touchbar item containing a custom view, controlled by a provided view controller

## Example

```swift
var sparklineVC = SparkViewController()
...
DSFTouchBar.View(
   DSFTouchBar.LeafIdentifier("throughput-sparkline"), 
   viewController: self.sparklineVC)
      .customizationLabel("Sparkline")
      .width(100)
```
