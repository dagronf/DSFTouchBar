//
//  ButtonsViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 7/9/20.
//

import Cocoa

class ButtonsViewController: NSViewController {

	@objc dynamic var enable3: Bool = false
	@objc dynamic var backgroundColor3: NSColor = .systemGreen
	@objc dynamic var button2State: NSButton.StateValue = .off {
		didSet {
			Swift.print("Button(2) - STATE CHANGE - \(button2State)")
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}

	@IBAction func toggleButton2(_ sender: Any) {
		self.button2State = (self.button2State == .on) ? .off : .on
	}

	deinit {
		Swift.print("Buttons deinit")
	}

	override func makeTouchBar() -> NSTouchBar? {

		let builder = DSFTouchBar.Builder(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.demo.buttons"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar.demo.buttons"),

			// Simple button

			DSFTouchBar.Button("button-1", customizationLabel: "Action Button")
				.title("Simple")
				.action { state in
					Swift.print("Button(1) - ACTION - \(state)")
				},

			// Button with simple static background color

			DSFTouchBar.Button("button-2", customizationLabel: "State-bound button")
				.title("OFF")
				.alternateTitle("ON")
				.backgroundColor(.brown)
				.bindState(to: self, withKeyPath: #keyPath(button2State)),

			DSFTouchBar.Spacer(size: .small),

			// Button with background and enabled color bindings

			DSFTouchBar.Button("button-3")
				.title("Good")
				.alternateTitle("Bad")
				.bindBackgroundColor(to: self, withKeyPath: #keyPath(backgroundColor3))
				.bindIsEnabled(to: self, withKeyPath: #keyPath(enable3))
				.action { [weak self] state in
					self?.backgroundColor3 = (state == .on) ? .systemRed : .systemGreen
				},

			// Button with image

			DSFTouchBar.Button("button-4")
				.title("Go")
				.image(NSImage(named: NSImage.touchBarGoForwardTemplateName))
				.imagePosition(.imageRight)
				.action { state in
					Swift.print("4 pressed - \(state)")
				},

			DSFTouchBar.OtherItemsPlaceholder()
		)

		return builder.makeTouchBar()
	}
}

extension ButtonsViewController: DemoContentViewController {
	static func Create() -> NSViewController {
		return ButtonsViewController()
	}
	static func Title() -> String {
		return "Buttons"
	}

	func cleanup() {
		self.touchBar = nil
	}
}
