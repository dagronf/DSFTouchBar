//
//  ViewController.swift
//  Touchbar Tester
//
//  Created by Darren Ford on 2/2/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

import Cocoa

import DSFTouchBar

fileprivate extension NSTouchBarItem.Identifier {
	//static let colorpop = NSTouchBarItem.Identifier("jp.mzp.touchbar.colopos")
	//static let colorpop2 = NSTouchBarItem.Identifier("jp.mzp.touchbar.colopos2")

	//static let kome1 = NSTouchBarItem.Identifier("jp.mzp.touchbar.kome1")
	//static let kome2 = NSTouchBarItem.Identifier("jp.mzp.touchbar.kome2")
	//static let kome3 = NSTouchBarItem.Identifier("jp.mzp.touchbar.kome3")
}

fileprivate extension NSTouchBar.CustomizationIdentifier {
	static let custom34 = NSTouchBar.CustomizationIdentifier("jp.mzp.touchbar.custom")
}

class ViewController: NSViewController {

	var customBar: DSFTouchBar?
	var colorVC = CustomColorViewController()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


	@objc dynamic var pickerColor: NSColor = .white {
		didSet {
			if let e = self.colorVC.view as? CustomColorView {
				e.color = self.pickerColor
			}
		}
	}

	@objc dynamic var swatchWidth: CGFloat = 150

	@objc dynamic var segmented = NSIndexSet() {
		didSet {
			Swift.print(segmented)
		}
	}

	override func viewDidAppear() {
		super.viewDidAppear()

		let c = NSMutableIndexSet()
		c.add(0)
		c.add(2)
		segmented = c
	}


	override func makeTouchBar() -> NSTouchBar? {

		self.customBar = DSFTouchBar(
			customizationIdentifier: .custom34,

				DSFTouchBar.ColorPicker(NSTouchBarItem.Identifier("jp.mzp.touchbar.kome1"))
					.customizationLabel("This is the color picker")
					.showAlpha(true)
					.bindSelectedColor(to: self, withKeyPath: #keyPath(pickerColor)),

				DSFTouchBar.Button(NSTouchBarItem.Identifier("jp.mzp.touchbar.kome2"))
					.customizationLabel("Reset back to defaults")
					.title("Reset")
					.action { [weak self] state in
						self?.pickerColor = NSColor.white
				},

			DSFTouchBar.View(NSTouchBarItem.Identifier("jp.mzp.touchbar.kome3"),
				viewController: self.colorVC)
					.customizationLabel("Color swatch")
					.width(100),

			DSFTouchBar.Spacer(size: .small),

			DSFTouchBar.Segmented(NSTouchBarItem.Identifier("jp.mzp.touchbar.fishy"), trackingMode: .selectAny)
				.add(label: "one")
				.add(label: "two")
				.add(label: "three")
				.bindSelectionIndexes(to: self, withKeyPath: #keyPath(segmented)),

			DSFTouchBar.Spacer(size: .small),

			DSFTouchBar.Popover(NSTouchBarItem.Identifier("jp.mzp.touchbar.colopos"),
				collapsedImage: NSImage.init(named: NSImage.touchBarGetInfoTemplateName)!, [
					DSFTouchBar.Button(NSTouchBarItem.Identifier("jp.mzp.touchbar.colopos2"))
						.customizationLabel("Noodle poodle")
						.title("Noodle")
				]
			),

			DSFTouchBar.OtherItemsPlaceholder()

		)
		return self.customBar?.makeTouchBar()
	}

}

class CustomColorView: NSView {

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.color = .systemPurple
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var color: NSColor = .clear {
		didSet {
			self.needsDisplay = true
		}
	}

	override func draw(_ dirtyRect: NSRect) {
		let b = self.bounds

		self.color.setFill()
		NSColor.white.setStroke()
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
