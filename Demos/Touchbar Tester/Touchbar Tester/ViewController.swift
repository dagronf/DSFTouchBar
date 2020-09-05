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

	lazy var groupInScrollGroup: DSFTouchBar.ScrollGroup = {
		return DSFTouchBar.ScrollGroup(
			NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup"), [
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.332232")).label("😀"),
				DSFTouchBar.Group(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasgroup.332232"), [
					DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.332234")).label("😀💝"),
					DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.332235")).label("😀👒"),
					DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.332236")).label("😀🐨"),
				]),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.332232")).label("🏓"),
			]
		)
	}()

	lazy var asgroup: DSFTouchBar.Group = {
		return DSFTouchBar.Group(
			NSTouchBarItem.Identifier("com.darrenford.touchbar.asgroup"), equalWidths: true, [
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.asgroup.332231")).label("Fish 1"),
				DSFTouchBar.ScrollGroup(
					NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup"), [
						DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.3322321")).label("😀1"),
						DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.3322322")).label("😀2"),
						DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.3322323")).label("😀3"),
						DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.3322324")).label("😀4"),
						DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.3322325")).label("😀5"),
						DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.3322326")).label("😀6"),
						DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.3322327")).label("😀7"),
						DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.sasscrollgroup.3322328")).label("😀8"),
				]),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.asgroup.332232")).label("😀"),
			])
	}()

	lazy var scrollGroup: DSFTouchBar.ScrollGroup = {
		return DSFTouchBar.ScrollGroup(
			NSTouchBarItem.Identifier("com.darrenford.touchbar.scrollgroup"), [
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3331")).label("Fish 1"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3332")).label("cat 2"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3333")).label("cat 3"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3334")).label("cat 4"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3335")).label("cat 5"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3336")).label("cat 6"),
				DSFTouchBar.Button(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3337")).title("Fred"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3338")).label("cat 8"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.33321")).label("cat 12"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.33331")).label("cat 13"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.33341")).label("cat 14"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.33351")).label("cat 15"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.33361")).label("cat 16"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.33371")).label("cat 17"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.33381")).label("cat 18"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.13331")).label("cat 1"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.13332")).label("cat 2"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.13333")).label("cat 3"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.13334")).label("cat 4"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.13335")).label("cat 5"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.13336")).label("cat 6"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.13337")).label("cat 7"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.13338")).label("cat 8"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.133321")).label("cat 12"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.133331")).label("cat 13"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.133341")).label("cat 14"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.133351")).label("cat 15"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.133361")).label("cat 16"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.133371")).label("cat 17"),
				DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.133381")).label("cat 18")
			]
		)
	}()

	lazy var popover: DSFTouchBar.Popover = {
		return DSFTouchBar.Popover(
			NSTouchBarItem.Identifier("com.darrenford.touchbar.segmented.colopos"),
			collapsedImage: NSImage.init(named: NSImage.touchBarGetInfoTemplateName)!, [

				DSFTouchBar.Group(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.grup"),
								  equalWidths: false, [
					DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.blah"))
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

	@objc var labelTitle: String = "Fish LT"

	@objc dynamic var attrt = NSAttributedString(
		string: "This is a test",
		attributes: [
			NSAttributedString.Key.font : NSFont(name: "Menlo", size: 17) //.boldSystemFont(ofSize: 18),
		])

	override func makeTouchBar() -> NSTouchBar? {

		self.customBar = DSFTouchBar(
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar"),

			DSFTouchBar.Text(NSTouchBarItem.Identifier("catdog")).label("Fish ->"),
//			self.groupInScrollGroup,
			self.asgroup,
//			self.scrollGroup,

//			DSFTouchBar.Text(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3331"))
//				//.label("Noodle"),
//				//.attributedLabel(attrt),
//				.bindAttributedTextLabel(to: self, withKeyPath: #keyPath(attrt)),
//				//.bindLabel(to: self, withKeyPath: #keyPath(labelTitle)),
//			DSFTouchBar.Button(NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3332"))
//				.title("Fish and chips")
//				.action { (state) in
//					Swift.print("Pressed!")
//				},

			//self.bbbbb,
			//self.scrollGroup,
//			self.colorPicker,
//			self.resetButton,
//			self.customColorView,

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

//		let i = self.customBar?.item(for: NSTouchBarItem.Identifier("com.darrenford.touchbar.popover.text.3332"))
//		assert(i is DSFTouchBar.Button)


		return self.customBar?.makeTouchBar()
	}

	@IBAction func changeAttributedString(_ sender: Any) {
		self.attrt = NSAttributedString(
			string: "Foot",
			attributes: [
				NSAttributedString.Key.font : NSFont.boldSystemFont(ofSize: 12),
		 ])
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
