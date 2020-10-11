//
//  ColorViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 9/9/20.
//

import Cocoa

import DSFTouchBar

class ColorViewController: NSViewController {

	let colorVC = CustomColorViewController()

	@objc dynamic var selectedColor: NSColor = .blue {
		didSet {
			if let e = self.colorVC.view as? CustomColorView {
				e.color = self.selectedColor
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}

	override func makeTouchBar() -> NSTouchBar? {

		let builder = DSFTouchBar.Build(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.demo.slider"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar.demo.slider")) {

			DSFTouchBar.ColorPicker("color-picker")
				.bindSelectedColor(to: self, withKeyPath: \ColorViewController.selectedColor)

			DSFTouchBar.View("colorswatch", viewController: self.colorVC)
				.customizationLabel("Color swatch")
				.width(75)

			DSFTouchBar.OtherItemsPlaceholder()
		}

		return builder.makeTouchBar()
	}

}

extension ColorViewController: DemoContentViewController {
	static func Create() -> NSViewController {
		return ColorViewController()
	}

	static func Title() -> String {
		return "Color Picker"
	}

	func cleanup() {
		self.touchBar = nil
	}
}

////// Custom Color View Controller

class CustomColorView: NSView {
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.color = .blue
	}

	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var color: NSColor = .clear {
		didSet {
			self.needsDisplay = true
		}
	}

	override func draw(_: NSRect) {
		let b = self.bounds.insetBy(dx: 1, dy: 1)

		self.color.setFill()
		NSColor.init(deviceWhite: 1.0, alpha: 0.4).setStroke()
		let pth = NSBezierPath(roundedRect: b, xRadius: 6, yRadius: 6)
		pth.setClip()
		pth.fill()
		pth.stroke()
	}
}

class CustomColorViewController: NSViewController {
	override func loadView() {
		self.view = CustomColorView(frame: .zero)
	}
}
