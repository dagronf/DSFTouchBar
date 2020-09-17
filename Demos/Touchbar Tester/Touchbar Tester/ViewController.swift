//
//  ViewController.swift
//  Touchbar Tester
//
//  Created by Darren Ford on 2/2/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

import Cocoa

import DSFTouchBar

import DSFSparkline

class ViewController: NSViewController {

	var colorVC = CustomColorViewController()

	let image = NSImage(named: "testimage")!

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

		//self.destroyToolBar()

		self.touchBar = nil

	}

	@objc dynamic var bbbbState: NSButton.StateValue = .off

	lazy var bbbbb: DSFTouchBar.Button = {
		DSFTouchBar.Button("bbgbuttons")
			.title("Fish")
			.alternateTitle("FISH!")
			.type(.toggle)
			.bindState(to: self, withKeyPath: #keyPath(bbbbState))
			.action { [weak self] state in
				self?.pickerColor = state == .off ? NSColor.white : NSColor.red
			}
	}()

	lazy var colorPicker: DSFTouchBar.ColorPicker = {
		DSFTouchBar.ColorPicker("colorpicker")
			.customizationLabel("This is the color picker")
			.showAlpha(true)
			.bindSelectedColor(to: self, withKeyPath: #keyPath(pickerColor))
	}()

	lazy var resetButton: DSFTouchBar.Button = {
		DSFTouchBar.Button("resetbutton")
			.customizationLabel("Reset back to defaults")
			.title("Reset")
			.color(NSColor.red)
			.foregroundColor(NSColor.white)
			.action { [weak self] _ in
				self?.pickerColor = NSColor.white
			}
	}()

	lazy var customColorView: DSFTouchBar.View = {
		DSFTouchBar.View("colorswatch", viewController: self.colorVC)
			.customizationLabel("Color swatch")
			//.width(50)
	}()

	lazy var segmentedControl: DSFTouchBar.Segmented = {
		DSFTouchBar.Segmented("segmented", trackingMode: .selectAny)
			.customizationLabel("Text Styles")
			.add(label: "􀅓", image: NSImage(named: NSImage.touchBarAudioOutputVolumeLowTemplateName))
			.add(label: "􀅔", image: NSImage(named: NSImage.touchBarAudioOutputVolumeMediumTemplateName))
			.add(label: "􀅕", image: NSImage(named: NSImage.touchBarAudioOutputVolumeHighTemplateName))
			.bindSelectionIndexes(to: self, withKeyPath: #keyPath(segmented))
	}()

	lazy var groupInScrollGroup: DSFTouchBar.ScrollGroup = {
		DSFTouchBar.ScrollGroup("scroll-group", [
			DSFTouchBar.Text("smiler").label("😀"),
			DSFTouchBar.Group("group", [
				DSFTouchBar.Text("heart").label("😀💝"),
				DSFTouchBar.Text("hat-bow").label("😀👒"),
				DSFTouchBar.Text("koala").label("😀🐨"),
			]),
			DSFTouchBar.Text("table-tennis").label("🏓"),
		])
	}()

	lazy var asgroup: DSFTouchBar.Group = {
		DSFTouchBar.Group("asgroup", equalWidths: true, [
			DSFTouchBar.Text("root_text").label("Fish 1"),
			DSFTouchBar.ScrollGroup("scrollgroup", [
				DSFTouchBar.Text("3322321").label("😀1"),
				DSFTouchBar.Text("3322322").label("😀2"),
				DSFTouchBar.Text("3322323").label("😀3"),
				DSFTouchBar.Text("3322324").label("😀4"),
				DSFTouchBar.Text("3322325").label("😀5"),
				DSFTouchBar.Text("3322326").label("😀6"),
				DSFTouchBar.Text("3322327").label("😀7"),
				DSFTouchBar.Text("3322328").label("😀8"),
			]),
			DSFTouchBar.Text("happy_smiley").label("😀"),
		])
		.customizationLabel("Group containing a scrollview")
	}()

	lazy var scrollGroup: DSFTouchBar.ScrollGroup = {
		DSFTouchBar.ScrollGroup("scrollgroup", [
			DSFTouchBar.Text("3331").label("Fish 1"),
			DSFTouchBar.Text("3332").label("cat 2"),
			DSFTouchBar.Text("3333").label("cat 3"),
			DSFTouchBar.Text("3334").label("cat 4"),
			DSFTouchBar.Text("3335").label("cat 5"),
			DSFTouchBar.Text("3336").label("cat 6"),
			DSFTouchBar.Button("3337").title("Fred").image(NSImage(named: NSImage.touchBarGoForwardTemplateName)),
			DSFTouchBar.Text("3338").label("cat 8"),
			DSFTouchBar.Text("33321").label("cat 12"),
			DSFTouchBar.Text("33331").label("cat 13"),
			DSFTouchBar.Text("33341").label("cat 14"),
			DSFTouchBar.Text("33351").label("cat 15"),
			DSFTouchBar.Text("33361").label("cat 16"),
			DSFTouchBar.Text("33371").label("cat 17"),
			DSFTouchBar.Text("33381").label("cat 18"),
			DSFTouchBar.Text("13331").label("cat 1"),
			DSFTouchBar.Text("13332").label("cat 2"),
			DSFTouchBar.Text("13333").label("cat 3"),
			DSFTouchBar.Text("13334").label("cat 4"),
			DSFTouchBar.Text("13335").label("cat 5"),
			DSFTouchBar.Text("13336").label("cat 6"),
			DSFTouchBar.Text("13337").label("cat 7"),
			DSFTouchBar.Text("13338").label("cat 8"),
			DSFTouchBar.Text("133321").label("cat 12"),
			DSFTouchBar.Text("133331").label("cat 13"),
			DSFTouchBar.Text("133341").label("cat 14"),
			DSFTouchBar.Text("133351").label("cat 15"),
			DSFTouchBar.Text("133361").label("cat 16"),
			DSFTouchBar.Text("133371").label("cat 17"),
			DSFTouchBar.Text("133381").label("cat 18"),
		])
	}()

	lazy var popover: DSFTouchBar.Popover = {
		DSFTouchBar.Popover(
			"base-popover",
			collapsedImage: NSImage(named: NSImage.touchBarGetInfoTemplateName)!, [
				DSFTouchBar.Group("popover.text.grup", equalWidths: false, [
					DSFTouchBar.Text("text.blah")
					.bindLabel(to: self, withKeyPath: #keyPath(popoverLabel)),

					DSFTouchBar.Button("buuuut2")
					.customizationLabel("22")
					.title("3")
					.action { [weak self] _ in
						Swift.print("Clicked noodle 2")
						self?.popoverLabel = "yumyum"
					},
				])
				.customizationLabel("Yum Yum Container"),
				DSFTouchBar.Slider("sklider", min: 0.0, max: 1.0)
				.bindValue(to: self, withKeyPath: #keyPath(sliderValue)),

				DSFTouchBar.Button("buuuut")
				.customizationLabel("Noodle poodle")
				.title("Noodle")
				.action { [weak self] _ in
					Swift.print("Clicked noodle")
					self?.popoverLabel = "CLICKY"
				},
			]
		).customizationLabel("Groovy popover!")
	}()

	/// Sparkline

	lazy var sparkline: DSFTouchBar.View = {
		return DSFTouchBar.View("sparkline", viewController: self.slvc)
			.customizationLabel("Sparkline")
			.width(50)
	}()

	var slvc = SparkViewController()
	class SparkViewController: NSViewController {
		let sparklineDataSource = DSFSparklineDataSource(windowSize: 20, range: 0.0 ... 1.0)
		override func loadView() {
			let sparklineView = DSFSparklineDotGraph()
			sparklineView.graphColor = NSColor.green
			sparklineView.unsetGraphColor = NSColor.darkGray
			sparklineView.showZero = false
			self.view = sparklineView
		}

		override func viewDidLoad() {
			super.viewDidLoad()
			(self.view as? DSFSparklineView)?.dataSource = sparklineDataSource

			self.updateWithNewValues()
		}

		func updateWithNewValues() {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
				guard let `self` = self else {
					return
				}

				let cr = CGFloat.random(in: 0.0 ... 1.0)
				_ = self.sparklineDataSource.push(value: cr)
				self.updateWithNewValues()
			}
		}
	}

	///

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
		return DSFTouchBar.SharingServicePicker("sharey", title: "Shared")
			.bindEnabled(to: self, withKeyPath: #keyPath(sharingAvailable))
			.provideItems { [weak self] in
				guard let `self` = self else { return [] }
				return [self.image]
			}
	}

	@objc dynamic var sharingAvailable = false
	@IBAction func toggleEnabled(_: Any) {
		sharingAvailable.toggle()
	}

	@objc var labelTitle: String = "Fish LT"

	@objc dynamic var attrt = NSAttributedString(
		string: "This is a test",
		attributes: [
			NSAttributedString.Key.font: NSFont(name: "Menlo", size: 17) as Any,
		]
	)


	@objc dynamic var dummyColor = NSColor.systemTeal
	@objc dynamic var enable3: Bool = false
	@objc dynamic var backgroundColor3: NSColor = .systemGreen

	override func makeTouchBar() -> NSTouchBar? {
		let touchbar = DSFTouchBar(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar"),

			//DSFTouchBar.Text("catdog").label("Fish ->"),
			//				self.groupInScrollGroup,
			//			self.asgroup,
			//			self.scrollGroup,

			// DSFTouchBar.Text("text.3331")
			// .label("Noodle"),
			// .attributedLabel(attrt)
			// .bindAttributedTextLabel(to: self, withKeyPath: #keyPath(attrt)),
			// .bindLabel(to: self, withKeyPath: #keyPath(labelTitle)),
			//			DSFTouchBar.Button("text.3332")
			//				.title("Fish and chips")
			//				.action { (state) in
			//					Swift.print("Pressed!")
			//				},

			 self.bbbbb,
						self.scrollGroup,

//			DSFTouchBar.Button("button-1")
//				.title("1")
//				.customizationLabel("The first button")
//				.action { state in
//					Swift.print("1 pressed - \(state)")
//				},
//
//			// Button with simple static background color
//
//			DSFTouchBar.Button("button-2")
//				.title("2")
//				.customizationLabel("The second button")
//				.color(.brown)
//				.action { state in
//					Swift.print("2 pressed - \(state)")
//				},
//
//			DSFTouchBar.Spacer(size: .small),
//
//			// Button with background and enabled color bindings
//
//			DSFTouchBar.Button("button-3")
//				.title("Good")
//				.alternateTitle("Bad")
//				.bindBackgroundColor(to: self, withKeyPath: #keyPath(backgroundColor3))
//				.bindEnabled(to: self, withKeyPath: #keyPath(enable3))
//				.action { state in
//					self.backgroundColor3 = (state == .on) ? .systemRed : .systemGreen
//				},
//
//			// Button with image
//
//			DSFTouchBar.Button("button-4")
//				.title("Go")
//				.image(NSImage(named: NSImage.touchBarGoForwardTemplateName))
//				.imagePosition(.imageRight)
//				.action { state in
//					Swift.print("4 pressed - \(state)")
//				},


//			DSFTouchBar.Group(
//				"Color Groups", equalWidths: true, [
//					self.colorPicker,
//					self.customColorView,
//					self.resetButton,
//					])
//				.customizationLabel("Color Group"),
//
//			self.smallSpacer,
//
//			self.segmentedControl,
//			self.sparkline,
//			self.smallSpacer,
//
//			self.popover,
//
//			self.sharingService,



			DSFTouchBar.OtherItemsPlaceholder()
		)

		return touchbar.makeTouchBar()
	}

	@IBAction func changeAttributedString(_: Any) {
		self.attrt = NSAttributedString(
			string: "Foot",
			attributes: [
				NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 12),
			]
		)
	}
}

extension ViewController: NSSharingServicePickerTouchBarItemDelegate {
	func items(for _: NSSharingServicePickerTouchBarItem) -> [Any] {
		return [image]
	}
}

class CustomColorView: NSView {
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.color = .systemPurple
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
