//
//  ViewController.swift
//  Touchbar Tester
//
//  Created by Darren Ford on 2/2/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

import Cocoa

import DSFTouchBar

class ViewController: NSViewController {

	var customBar: DSFTouchBar?
	var colorVC = CustomColorViewController()

	let image = NSImage(named: "testimage")!

	deinit {
		self.customBar?.destroy()
		self.customBar = nil
	}

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

	override func viewWillDisappear() {
		super.viewWillDisappear()

		self.customBar?.destroy()
	}

	@objc dynamic var bbbbState: NSButton.StateValue = .off

	lazy var bbbbb: DSFTouchBar.Button = {
		return DSFTouchBar.Button(NSTouchBarItem.Identifier("com.darrenford.touchbar.colorpicker2"))
			.title("Fish")
			.alternateTitle("FISH!")
			.type(.toggle)
			.bindState(to: self, withKeyPath: #keyPath(bbbbState))
			.action { [weak self] state in
				self?.pickerColor = state == .off ? NSColor.white : NSColor.red
			}
	}()


	lazy var colorPicker: DSFTouchBar.ColorPicker = {
		return DSFTouchBar.ColorPicker(
			NSTouchBarItem.Identifier("com.darrenford.touchbar.colorpicker"))
			.customizationLabel("This is the color picker")
			.showAlpha(true)
			.bindSelectedColor(to: self, withKeyPath: #keyPath(pickerColor))
	}()

	lazy var resetButton: DSFTouchBar.Button = {
		return DSFTouchBar.Button(
			NSTouchBarItem.Identifier("com.darrenford.touchbar.resetbutton"))
			.customizationLabel("Reset back to defaults")
			.title("Reset")
			.action { [weak self] state in
				self?.pickerColor = NSColor.white
			}
	}()

	lazy var customColorView: DSFTouchBar.View = {
		return DSFTouchBar.View(
			NSTouchBarItem.Identifier("com.darrenford.touchbar.colorswatch"),
			viewController: self.colorVC)
			.customizationLabel("Color swatch")
			.width(100)
	}()

	lazy var segmentedControl: DSFTouchBar.Segmented = {
		return DSFTouchBar.Segmented(
			NSTouchBarItem.Identifier("com.darrenford.touchbar.segmented"), trackingMode: .selectAny)
			.add(label: "􀅓")
			.add(label: "􀅔")
			.add(label: "􀅕")
			.bindSelectionIndexes(to: self, withKeyPath: #keyPath(segmented))
	}()

	lazy var scrollGroup: DSFTouchBar.ScrollGroup = {
		return DSFTouchBar.ScrollGroup(
			NSTouchBarItem.Identifier(
				"com.darrenford.touchbar.scrollgroup"),
			DSFTouchBar.Group(
				NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.222"),
				equalWidths: false, [
					DSFTouchBar.Text(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3331"), label: "cat 1"),
					DSFTouchBar.Text(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3332"), label: "cat 2"),
					DSFTouchBar.Text(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3333"), label: "cat 3"),
					DSFTouchBar.Text(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3334"), label: "cat 4"),
					DSFTouchBar.Text(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3335"), label: "cat 5"),
					DSFTouchBar.Text(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3336"), label: "cat 6"),
					DSFTouchBar.Text(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3337"), label: "cat 7"),
					DSFTouchBar.Text(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3338"), label: "cat 8")
				]
			)
		)
	}()

	lazy var popover: DSFTouchBar.Popover = {
		return DSFTouchBar.Popover(
			NSTouchBarItem.Identifier("com.darrenford.touchbar.segmented.colopos"),
			collapsedImage: NSImage.init(named: NSImage.touchBarGetInfoTemplateName)!, [

				DSFTouchBar.Group(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.grup"),
								  equalWidths: false, [
					DSFTouchBar.Text(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.blah"), label: "")
					.bindLabel(to: self, withKeyPath: #keyPath(popoverLabel)),

					DSFTouchBar.Button(NSTouchBarItem.Identifier("com.darrenford.touchbar.buuuut2"))
						.customizationLabel("22")
						.title("3")
					.action { [weak self] _ in
						Swift.print("Clicked noodle 2")
						self?.popoverLabel = "yumyum"
					}
				]),
				DSFTouchBar.Slider(identifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.sklider"),
								   min: 0.0, max: 1.0)
				.bindValue(to: self, withKeyPath: #keyPath(sliderValue)),

				DSFTouchBar.Button(NSTouchBarItem.Identifier("com.darrenford.touchbar.buuuut"))
					.customizationLabel("Noodle poodle")
					.title("Noodle")
				.action { [weak self] _ in
					Swift.print("Clicked noodle")
					self?.popoverLabel = "CLICKY"
				}
			]
		)
	}()

	@objc dynamic var popoverLabel = "Fish and chips ->"
	@objc dynamic var sliderValue: CGFloat = 0.75 {
		didSet {
			Swift.print("slider changed - \(sliderValue)")
		}
	}

	var smallSpacer: DSFTouchBar.Spacer {
		return DSFTouchBar.Spacer(size: .small)
	}

	///// Sharing service test

	var sharingService: DSFTouchBar.SharingServicePicker {
		return DSFTouchBar.SharingServicePicker(
			identifier: NSTouchBarItem.Identifier("com.darrenford.sharey"),
			title: "Shared")
			.bindEnabled(to: self, withKeyPath: #keyPath(sharingAvailable))
			.provideItems { [weak self] in
				guard let `self` = self else { return [] }
				return [self.image]
			}
	}

	@objc dynamic var sharingAvailable = false
	@IBAction func toggleEnabled(_ sender: Any) {
		sharingAvailable.toggle()
	}

	override func makeTouchBar() -> NSTouchBar? {

		self.customBar = DSFTouchBar(
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar"),

			//self.bbbbb,
			//self.scrollGroup,
			self.colorPicker,
			self.resetButton,
			self.customColorView,

//			self.smallSpacer,
//
//			self.segmentedControl,
//
//			self.smallSpacer,
//
//			self.popover,
//
//			self.sharingService,

			DSFTouchBar.OtherItemsPlaceholder()
		)
		return self.customBar?.makeTouchBar()
	}
}

extension ViewController: NSSharingServicePickerTouchBarItemDelegate {
	func items(for pickerTouchBarItem: NSSharingServicePickerTouchBarItem) -> [Any] {
		return [image]
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
