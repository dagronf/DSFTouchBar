# DSFTouchBar

A description of this package.

## Concepts

### baseIdentifier

The baseIdentifier for the toolbar provides the 'root' identifier for all of the children.  When a toolbar item is added, the identifier provided for the item is appended to the baseIdentifier to make a unique identifier.

This is done to try to reduce the verboseness of specifying a full identifier for each child of the toolbar.  

So, for example :-

```swift
override func makeTouchBar() -> NSTouchBar? {
   DSFTouchBar(
      baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.dsftouchbar.documentation"),
      customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.dsftouchbar.documentation.docodemo")) {

      // This button will have the unique identifier 'com.darrenford.dsftouchbar.documentation.edit-document'
      DSFTouchBar.Button("edit-document")
         .title("Edit")
         .type(.onOff)
         .bindState(to: self, withKeyPath: \ViewController.editbutton_state)
         .bindBackgroundColor(to: self, withKeyPath: \ViewController.editBackgroundColor)
         .action { _ in
            Swift.print("Edit button pressed")
         }

      // This button will have the unique identifier 'com.darrenford.dsftouchbar.documentation.upgrade-document'
      DSFTouchBar.Button("upgrade-document")
         .title("Upgrade")
         .bindIsEnabled(to: self, withKeyPath: \ViewController.canEdit)
         .bindBackgroundColor(to: self, withKeyPath: \ViewController.upgradeBackgroundColor)
         .action { _ in
            Swift.print("Upgrade button pressed")
         }

      // This button will have the unique identifier 'com.darrenford.dsftouchbar.documentation.go-document'
      DSFTouchBar.Button("go-button")
         .title("Go")
         .image(NSImage(named: NSImage.touchBarGoForwardTemplateName))
         .imagePosition(.imageRight)
         .action { state in
            Swift.print("GO!")
         }

      DSFTouchBar.OtherItemsPlaceholder()
   }
   .makeTouchBar()
}
```

# Supported TouchBar Items

| Type              | Description                                 |
|:------------------|:--------------------------------------------|
| [Label](../label.md) | Add a label to the touchbar |
| [Button](../button.md) | Add a button to the touchbar |
| [Segmented](../segmented.md) | Add a segmented control to the touchbar |
| [Slider](../segmented.md) | Add a slider control to the touchbar |
| [ColorPicker](../colorpicker.md) | Add a color picker control to the touchbar |
| [SharingServicePicker](../sharing-service.md) | Add a button that presents the sharing services when pressed |
| [View](../view.md) | Add a custom view to the touch bar |
| [Popover](../popover.md) | Add a popover |
| [Group](../group.md) | Add an item that contains a grouping of other items |
| [ScrollGroup](../group.md) | Add an item that contains a scrollable grouping of other items |

# Support issues

## My touchbar is not showing!

The touchbar will only be shown for a view that **accepts first responder** (ie. acceptsFirstResponder == true for the view)

## One of the items in a touchbar is not showing!

Check to see that the `leafIdentifier` for all controls is unique.

# Releases

## 0.1.0

Initial public release.

# License

MIT. Use it for anything you want! Let me know if you do use it somewhere, I'd love to hear about it.

```
MIT License

Copyright (c) 2021 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
