# Popover

Add a popover to the touch bar.  The popover appears as a simple item which, when pressed, overlays another collection of items

## Example

```swift
DSFTouchBar.Popover("popover", 
   customizationLabel: "Smiles",
   collapsedLabel: "Smiles",
   collapsedImage: NSImage(named: NSImage.touchBarGetInfoTemplateName)!) {
      DSFTouchBar.Text("heart").label("😀💝")
      DSFTouchBar.Text("hat-bow").label("😀👒")
      DSFTouchBar.Text("koala").label("😀🐨")
}
```
