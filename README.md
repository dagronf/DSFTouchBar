# DSFTouchBar

![](https://img.shields.io/github/v/tag/dagronf/DSFTouchBar) ![](https://img.shields.io/badge/macOS-10.13+-blueviolet) ![](https://img.shields.io/badge/Swift-5.1+-orange.svg)
![](https://img.shields.io/badge/License-MIT-lightgrey) [![](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

A SwiftUI-style declarative `NSTouchBar` for AppKit.

## Why?

`NSTouchBar` has an amazing API with incredible flexibility, but I find that it can be too verbose and spread throughout your code with the use of delegates and callbacks for simpler projects and I have trouble keeping tabs on all the individual components. Even moreso if you want to use actions and bindings on the touchbar objects which just increases the amount code required for each touchbar.

Give that I'd written a SwiftUI-style declarative API for [`NSToolbar`]() I adapted the API for `NSTouchBar`.

I know that I'm late to the game here - but there's still going to be quite a while before a lot of existing apps can migrate upwards to SwiftUI (especially my own small apps).

If you're going pure SwiftUI now for your apps, you should use the `touchbar(_:)` ViewModifier.

[SwiftUI TouchBar support](https://developer.apple.com/documentation/swiftui/groupbox/touchbar(_:))

## TL;DR - Show me something!

If you're familiar with SwiftUI syntax you'll feel comfortable with the declaration style.

```swift
class ViewController: NSViewController {

   @objc dynamic var editbutton_state: NSButton.ControlState = .off
   @objc dynamic var canEdit: Bool = false
   @objc dynamic var upgradeBackgroundColor: NSColor = .clear

   override func makeTouchBar() -> NSTouchBar? {
      DSFTouchBar(
         baseIdentifier: .init("com.myapp.touchbardemo.documentation"),
         customizationIdentifier: .init("com.myapp.touchbardemo.documentation.docodemo")) {

         // This button will have the unique identifier 'com.darrenford.dsftouchbar.documentation.edit-document'
         DSFTouchBar.Button(.init("edit-document"))
            .title("Edit")
            .type(.onOff)
            .bindState(to: self, withKeyPath: \ViewController.editbutton_state)
            .bindBackgroundColor(to: self, withKeyPath: \ViewController.editBackgroundColor)
            .action { _ in
               Swift.print("Edit button pressed")
            }

         // This button will have the unique identifier 'com.darrenford.dsftouchbar.documentation.upgrade-document'
         DSFTouchBar.Button(.init("upgrade-document"))
            .title("Upgrade")
            .bindIsEnabled(to: self, withKeyPath: \ViewController.canEdit)
            .bindBackgroundColor(to: self, withKeyPath: \ViewController.upgradeBackgroundColor)
            .action { _ in
               Swift.print("Upgrade button pressed")
            }

         // This button will have the unique identifier 'com.darrenford.dsftouchbar.documentation.go-document'
         DSFTouchBar.Button(.init("go-button"))
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
}
```

[Sample Code](../Demos/DSFTouchBar%20Demo/Doco%20Demo/ViewController.swift)

# Supported TouchBar Items

| Type              | Description                                 |
|:------------------|:--------------------------------------------|
| [Button](./Markdown/button.md) | Add a button to the touchbar |
| [ColorPicker](./Markdown/colorpicker.md) | Add a color picker control to the touchbar |
| [Group](./Markdown/group.md) | Add an item that contains a grouping of other items |
| [Label](./Markdown/label.md) | Add a label to the touchbar |
| [Popover](./Markdown/popover.md) | Add a popover |
| [ScrollGroup](./Markdown/group.md) | Add an item that contains a scrollable grouping of other items |
| [Segmented](./Markdown/segmented.md) | Add a segmented control to the touchbar |
| [SharingServicePicker](./Markdown/sharing-service.md) | Add a button that presents the sharing services when pressed |
| [Slider](./Markdown/segmented.md) | Add a slider control to the touchbar |
| [View](./Markdown/view.md) | Add a custom view to the touch bar |
| OtherItems |  A special "other items proxy", which is used to nest touch bars up the responder chain.<br/>Refer to [Apple's documentation](https://developer.apple.com/documentation/appkit/nstouchbaritem/identifier/2544791-otheritemsproxy) for more information |
# DSFTouchBar Concepts

## baseIdentifier

The baseIdentifier for the toolbar provides the 'root' identifier for all of the children.  When a toolbar item is added, the identifier provided for the item is appended to the baseIdentifier to make a unique identifier.

This is done to try to reduce the verboseness of specifying a full identifier for each child of the toolbar.  

```swift
DSFTouchBar(baseIdentifier: .init("com.myapp.touchbardemo")) {
     DSFTouchBar.Button(.init("edit-document"))  // identifier is 'com.myapp.touchbardemo.edit-document'
}  
```

## customizationIdentifier

The customization identifier allows the touchbar to be customized.  The identifier is used when storing the configuration for the touchbar to disk.

```swift
DSFTouchBar(
   baseIdentifier: .init("com.myapp.touchbardemo"),
   customizationIdentifier: .init("com.myapp.touchbardemo.settings")) {
      DSFTouchBar.Button(.init("edit-document"))  // identifier is 'com.myapp.touchbardemo.edit-document'
}  
```

# Demos

You can find some demos for macOS in the `Demos` subfolder

# Support issues

## My touchbar is not showing!

The touchbar will only be shown for a view/control that **accepts first responder** (ie. acceptsFirstResponder == true for the view)

## One of the items in a touchbar is not showing!

Check to see that the `leafIdentifier` for all controls is unique.

## User customization issues

#### The touchbar menu item is disabled!

You need to tell your app to enable customize touchbar behaviour.

```swift
NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
```

#### My touchbar still doesn't enable the touchbar menu item!

You can only customize a touchbar that has a `customizationIdentifier` specified for it.

```swift
DSFTouchBar(
   baseIdentifier: .init("com.myapp.documentation"),
   customizationIdentifier: .init("com.myapp.documentation.docodemo")) {
```

#### I'm seeing !Missing Label! in the customization pane!

You need to specify a `customizationLabel` for each DSFTouchBar item.

```swift
DSFTouchBar.Button(.init("edit-document"), customizationLabel: "Edit Document")
```

# Releases

## 0.1.0

Initial release.

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
