//
//  PopoverViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 11/9/20.
//

import Cocoa

import DSFTouchBar

class PopoverViewController: NSViewController {

	@objc dynamic var popoverSliderIntValue: Int = 40
	@objc dynamic var popoverSliderValue: CGFloat = 40 {
		didSet {
			let newValue = Int(floor(popoverSliderValue))
			if newValue != popoverSliderIntValue {
				Swift.print("slider changed - \(newValue)")
				popoverSliderIntValue = newValue
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}

	func popoverContent() -> DSFTouchBar.Popover {
		let buttonImage = NSImage(named: NSImage.touchBarGetInfoTemplateName)!
		return DSFTouchBar.Popover(DSFTouchBar.LeafIdentifier("base-popover"), collapsedImage: buttonImage, [
			DSFTouchBar.Button(DSFTouchBar.LeafIdentifier("reset-button"))
				.customizationLabel("Reset Button")
				.title("Reset")
				.backgroundColor(.systemRed)
				.action { [weak self] _ in
					// Reset slider back to default
					self?.popoverSliderValue = 40
				}
			,
			DSFTouchBar.Slider(DSFTouchBar.LeafIdentifier("slider"), minValue: 0.0, maxValue: 100.0)
				.bindValue(to: self, withKeyPath: \PopoverViewController.popoverSliderValue)
		])
	}

	override func makeTouchBar() -> NSTouchBar? {
		let bar = DSFTouchBar(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.demo.popover"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar.demo.popover")) {
			DSFTouchBar.Label(DSFTouchBar.LeafIdentifier("root_text")).label("Popover ->")
			self.popoverContent()
			DSFTouchBar.OtherItemsPlaceholder()
		}
		return bar.makeTouchBar()
	}
}

extension PopoverViewController: DemoContentViewController {
	static func Create() -> NSViewController {
		return PopoverViewController()
	}

	static func Title() -> String {
		return "Popover"
	}

	func cleanup() {
		self.touchBar = nil
	}
}
