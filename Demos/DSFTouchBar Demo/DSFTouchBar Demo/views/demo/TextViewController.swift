//
//  TextViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 8/9/20.
//

import Cocoa

import DSFTouchBar

class TextViewController: NSViewController {

	var customBar: DSFTouchBar?

	@objc dynamic var simpleAttributedString = NSAttributedString(
		string: "Noodles!",
		attributes: [
			.font: NSFont(name: "Menlo", size: 17) as Any,
			NSAttributedString.Key.foregroundColor: NSColor.systemYellow,
		]
	)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

	override func makeTouchBar() -> NSTouchBar? {
		let builder = DSFTouchBar(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.demo.labels"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar.demo.labels"),

			// Simple text label

			DSFTouchBar.Text("label-1")
				.customizationLabel("Static Label Text")
				.label("First ->"),

			// Simple attributed text label

			DSFTouchBar.Text("label-2")
				.customizationLabel("AttributedString with bindings")
				.bindAttributedTextLabel(to: self, withKeyPath: #keyPath(simpleAttributedString)),

			DSFTouchBar.OtherItemsPlaceholder()
		)

		return builder.makeTouchBar()
	}
}

extension TextViewController: DemoContentViewController {
	static func Create() -> NSViewController {
		return TextViewController()
	}
	static func Title() -> String {
		return "Labels"
	}
	func cleanup() {
		self.touchBar = nil
	}
}

extension TextViewController: NSTextFieldDelegate {
	func controlTextDidChange(_ obj: Notification) {
		guard let textField = obj.object as? NSTextField else {
			fatalError()
		}

		simpleAttributedString = textField.attributedStringValue
	}
}
