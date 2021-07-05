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

# Available Controls

| Type              | Description                                 |
|:------------------|:--------------------------------------------|
| [Label](../label.md) | Adds a label to the touchbar |
| [Button](../button.md) | Adds a button to the touchbar |
| [Segmented](../segmented.md) | Adds a segmented control to the touchbar |
| [Slider](../segmented.md) | A bar item that provides a slider control for choosing a value in a range |

## ColorPicker

Adds a color picker control to the touchbar

### Example

```swift
@objc dynamic var pickerColor: NSColor = .white
  …
DSFTouchBar.ColorPicker(NSTouchBarItem.Identifier("com.superblah.TextField"))
   .customizationLabel("Character Color")
   .showAlpha(true)
   .bindSelectedColor(to: self, withKeyPath: #keyPath(pickerColor))
```

<details>
<summary>Settings</summary>

### Settings

| Method              | Type                 | Description                       |
|:--------------------|:---------------------|:----------------------------------|
| `showAlpha`         | `Bool`               | Whether the color picker should allow transparency |
| `customizationLabel`| `String`             | The label to display when customizing the touch bar |

### Actions

| Method              | Type                 | Description                       |
|:--------------------|:---------------------|:----------------------------------|
| `action`            | `(NSColor) -> Void`  | A block which gets called when the user selects a color |

### Bindings

| Method               | Type           | Description                                                     |
|:---------------------|:---------------|:----------------------------------------------------------------|
| `bindSelectedColor`  | `NSColor`      | Create a two-way binding for the color to the specified keyPath |
| `bindIsEnabled`      | `Bool`         | Bind the enabled state to a keypath |

</details>

## SharingServicePicker

Add a button that presents the sharing services when pressed

### Example

```swift
@objc dynamic var sharingAvailable = false
var selectedText = "some text"
...
DSFTouchBar.SharingServicePicker("sharey", title: "Share")
   .bindIsEnabled(to: self, withKeyPath: \MyViewController.sharingAvailable)
   .provideItems { [weak self] in
      guard let `self` = self else { return [] }
      return [self.selectedText]
   }
```
<details>
<summary>Settings</summary>

### Settings

| Method            | Type                 | Description                        |
|:------------------|:---------------------|:-----------------------------------|
| `title`  | `String?`  | An optional title to be displayed on the share button |
| `image`  | `NSImage?` | An optional image to be displayed on the share button |

### Actions

| Method            | Type           | Description                               |
|:------------------|:---------------|:------------------------------------------|
| `provideItems`    | `() -> [Any]`  | Called to retrieve the items to be shared |

### Bindings

| Method            | Type           | Description                         |
|:------------------|:---------------|:------------------------------------|
| `bindIsEnabled`   | `Bool`         | Bind the enabled state to a keypath |

</details>

## View

Adds a custom view to the touch bar

### Example

```swift
var sparklineVC = SparkViewController()
...
DSFTouchBar.View("throughput-sparkline", viewController: self.sparklineVC)
   .customizationLabel("Sparkline")
   .width(100)
```

<details>
<summary>Settings</summary>

### Settings

None

</details>

## Popover

Add a popover to the touch bar.  The popover appears as a simple item which, when pressed, overlays another collection of items

### Example

```swift
DSFTouchBar.Popover("base-popover", collapsedImage: buttonImage, 
   [
      DSFTouchBar.Button("tweak-button")
         ...
      ,
      DSFTouchBar.Slider("slider", min: 0.0, max: 100.0)
         ...
      ,
      DSFTouchBar.Button("reset-button")
         ...
   ]
)
```
<details>
<summary>Settings</summary>

### Settings

| Method            | Type                 | Description                       |
|:------------------|:---------------------|:----------------------------------|
| `collapsedLabel`  | `String?`  | the label to display when the popover content isn't visible |
| `collapsedImage`  | `NSColor?` | the image to display when the popover content isn't visible |

</details>

## Group

Add an item that contains a grouping of other items.

### Example

```swift
DSFTouchBar.Group("base-popover") { 
   DSFTouchBar.Button("tweak-button")
      ...
   DSFTouchBar.Slider("slider", min: 0.0, max: 100.0)
      ...
   DSFTouchBar.Button("reset-button")
      ...
)
```

<details>
<summary>Settings</summary>

### Settings

None

</details>

## ScrollGroup

Add an item that contains a grouping of other items which will scroll as the user drags their finger across the group in the touchbar.

### Example

```swift
DSFTouchBar.ScrollGroup("base-popover", collapsedImage: buttonImage) {
   DSFTouchBar.Button("first-button")
      ...
   DSFTouchBar.Button("second-button")
      ...
   DSFTouchBar.Button("third-button")
      ...
}
```

<details>
<summary>Settings</summary>

### Settings

None

</details>

# Support issues

## My touchbar is not showing!

The touchbar will only be shown for a view that accepts first responder (ie. acceptsFirstResponder == true for the view)

# Releases



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
