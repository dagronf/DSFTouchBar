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


# Controls

## Button

### Settings

| Method            | Type                 | Description                                                         |
|:------------------|:---------------------|:--------------------------------------------------------------------|
| `title`           | `String`             | The plain text displayed on the button                              |
| `alternateTitle`  | `String`             | The title that is displayed when the button is on (for on/off types |
| `attributedTitle` | `NSAttributedString` | The attributed text displayed on the button                         |
| `attributedAlternateTitle` | `NSAttributedString` | The title that is displayed when the button is on (for on/off types |
| `color` | `NSColor` | The background color for the button |
| `image` | `NSImage` | The button image to use |
| `action` | `(NSControl.StateValue) -> Void` | A block which gets called when the user interacts with the button |
| `customizationLabel`| `String`             | The label to display when customizing the touch bar |


### Bindings

| Method            | Type                   | Description                                                         |
|:------------------|:-----------------------|:--------------------------------------------------------------------|
| `bindState`       | `NSControl.StateValue` | Create a two-way state binding to the specified keyPath |

### Example

```swift
@objc dynamic var pressedState: NSControl.StateValue = .off
  …
DSFTouchBar.Button(NSTouchBarItem.Identifier("com.superblah.button1"), type: .onOff))
   .title("Press")
   .alternateTitle("Pressed")
   .customizationLabel("Activation Button")
   .bindState(to: self, withKeyPath: #keyPath(buttonState))
```

## Text

### Settings

| Method              | Type                 | Description                       |
|:--------------------|:---------------------|:----------------------------------|
| `label`             | `String`             | The plain text displayed          |
| `attributedLabel`   | `NSAttributedString` | The attributed text displayed     |
| `customizationLabel`| `String`             | The label to display when customizing the touch bar |

### Bindings

| Method            | Type                   | Description                                                         |
|:------------------|:-----------------------|:--------------------------------------------------------------------|
| `bindLabel`       | `String`   | Create a binding for the label to the specified keyPath |

### Example

```swift
@objc dynamic var labelText: String = ""
  …
DSFTouchBar.Text(NSTouchBarItem.Identifier("com.superblah.TextField"), label: "None")
   .bindLabel(to: self, withKeyPath: #keyPath(labelText))
```

  
## Segmented

Implements a segmented control within the touch bar

### Settings

| Method              | Type               | Description                       |
|:--------------------|:-------------------|:----------------------------------|
| `add`               | `String`/`NSImage` | Add a new segment containing a String, NSImage or both |
| `action`            | `([Int]) -> Void`  | A block which gets called when the user changes the segmented control selection |
| `customizationLabel`| `String`           | The label to display when customizing the touch bar |

### Bindings

| Method               | Type           | Description                                                     |
|:---------------------|:---------------|:----------------------------------------------------------------|
| `bindSelectedIndex` | `Int` | Create a two-way binding for a single selection state to the specified `keyPath` |
| `bindSelectionIndexes`  | `NSIndexSet` | Create a two-way binding for the multiple  selection state to the specified `keyPath` |

### Example

```swift
@objc dynamic var selectedSegments = NSIndexSet()
  …
DSFTouchBar.Segmented(NSTouchBarItem.Identifier("com.superblah.Segmented"), trackingMode: .selectAny)
   .add(label: "one")
   .add(label: "two")
   .add(label: "three")
   .bindSelectionIndexes(to: self, withKeyPath: #keyPath(selectedSegments)),
```

## Slider

Implements a slider control within the touch bar

### Settings

| Method                  | Type                | Description                       |
|:------------------------|:--------------------|:----------------------------------|
| `label`                 | `String`            | The label displayed to the left of the slider |
| `minimumValueAccessory` | `NSImage`           | Set the minimum accessory image for the slider |
| `maximumValueAccessory` | `NSImage`           | Set the maximum accessory image for the slider |    
| `action`                | `(CGFloat) -> Void` | A block which gets called when the user changes the slider position |
| `customizationLabel`    | `String`            | The label to display when customizing the touch bar |

### Bindings

| Method               | Type           | Description                                                     |
|:---------------------|:---------------|:----------------------------------------------------------------|
| `bindValue `  | `CGFloat` | Create a two-way binding for slider's value to the specified `keyPath` |

### Example

```swift
@objc dynamic var sliderValue: CGFloat = 0.0 {
  …
DSFTouchBar.Slider(identifier: "squish", min: 0.0, max: 10.0)
   .label("Slider")
   .minimumValueAccessory(image: NSImage(named: NSImage.touchBarAudioOutputVolumeOffTemplateName))
   .maximumValueAccessory(image: NSImage(named: NSImage.touchBarAudioOutputVolumeHighTemplateName))
   .bindValue(to: self, withKeyPath: #keyPath(sliderValue))
   .action { value in
      //Swift.print("\(value)")
   }
```

## ColorPicker

### Settings

| Method              | Type                 | Description                       |
|:--------------------|:---------------------|:----------------------------------|
| `showAlpha`         | `Bool`               | Whether the color picker should allow transparency |
| `action`            | `(NSColor) -> Void`  | A block which gets called when the user selects a color |
| `customizationLabel`| `String`             | The label to display when customizing the touch bar |

### Bindings

| Method               | Type           | Description                                                     |
|:---------------------|:---------------|:----------------------------------------------------------------|
| `bindSelectedColor`  | `NSColor`      | Create a two-way binding for the color to the specified keyPath |

### Example

```swift
@objc dynamic var pickerColor: NSColor = .white
  …
DSFTouchBar.ColorPicker(NSTouchBarItem.Identifier("com.superblah.TextField"))
   .customizationLabel("Character Color")
   .showAlpha(true)
   .bindSelectedColor(to: self, withKeyPath: #keyPath(pickerColor))
					
```

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
