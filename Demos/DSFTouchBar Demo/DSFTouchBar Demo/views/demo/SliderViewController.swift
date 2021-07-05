//
//  SliderViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 8/9/20.
//

import Cocoa

import DSFTouchBar

class SliderViewController: NSViewController {

	@objc dynamic var showAccessories: Bool = false {
		didSet {
			if self.showAccessories {
				slider.minimumValueAccessory(image: NSImage(named: NSImage.touchBarUserTemplateName))
				slider.maximumValueAccessory(image: NSImage(named: NSImage.touchBarUserGroupTemplateName))
			}
			else {
				slider.minimumValueAccessory(image: nil)
				slider.maximumValueAccessory(image: nil)
			}
		}
	}

	@objc dynamic var sliderValue: CGFloat = 0.75

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}

	lazy var slider: DSFTouchBar.Slider = {
		DSFTouchBar.Slider(DSFTouchBar.LeafIdentifier("primary"), minValue: 0.0, maxValue: 1.0)
			.label("Slider")
			.bindValue(to: self, withKeyPath: \SliderViewController.sliderValue)
	}()

	var customBar: DSFTouchBar {
		return DSFTouchBar(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.demo.slider"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar.demo.slider")) {

			DSFTouchBar.Button(DSFTouchBar.LeafIdentifier("reset"))
				.title("Reset")
				.backgroundColor(.systemRed)
				.action { _ in
					self.sliderValue = 0.66
				}

			self.slider

			DSFTouchBar.OtherItemsPlaceholder()
		}
	}

	override func makeTouchBar() -> NSTouchBar? {
		return self.customBar.makeTouchBar()
	}
}

extension SliderViewController: DemoContentViewController {
	static func Create() -> NSViewController {
		return SliderViewController()
	}

	static func Title() -> String {
		return "Sliders"
	}

	func cleanup() {
		self.touchBar = nil
	}
}
