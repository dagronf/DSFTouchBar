# View

A touchbar item containing a custom view, controlled by a supplied view controller

## Example

```swift
var sparklineVC = SparkViewController()
...
DSFTouchBar.View("throughput-sparkline", viewController: self.sparklineVC)
   .customizationLabel("Sparkline")
   .width(100)
```
