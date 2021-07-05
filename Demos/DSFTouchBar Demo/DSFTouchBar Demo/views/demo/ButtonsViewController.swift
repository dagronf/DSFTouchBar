//
//  ButtonsViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 7/9/20.
//

import Cocoa
import DSFTouchBar

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

		let builder = DSFTouchBar(
			baseIdentifier: .init("com.darrenford.touchbar.demo.buttons"),
			customizationIdentifier: .init("com.darrenford.touchbar.demo.buttons")) {

			// Simple button

			DSFTouchBar.Button(.init("button-1"), customizationLabel: "Action Button")
				.title("Simple")
				.action { state in
					Swift.print("Button(1) - ACTION - \(state)")
				}

			// Button with simple static background color

			DSFTouchBar.Button(.init("button-2"), customizationLabel: "State-bound button")
				.title("OFF")
				.alternateTitle("ON")
				.backgroundColor(.brown)
				.bindState(to: self, withKeyPath: \ButtonsViewController.button2State)

			DSFTouchBar.Spacer(size: .small)

			// Button with background and enabled color bindings

			DSFTouchBar.Button(.init("button-3"))
				.title("Good")
				.alternateTitle("Bad")
				.bindBackgroundColor(to: self, withKeyPath: \ButtonsViewController.backgroundColor3)
				.bindIsEnabled(to: self, withKeyPath: \ButtonsViewController.enable3)
				.action { [weak self] state in
					self?.backgroundColor3 = (state == .on) ? .systemRed : .systemGreen
				}

			// Button with image

			DSFTouchBar.Button(.init("button-4"))
				.title("Go")
				.image(NSImage(named: NSImage.touchBarGoForwardTemplateName))
				.imagePosition(.imageRight)
				.action { state in
					Swift.print("4 pressed - \(state)")
				}

			DSFTouchBar.OtherItemsPlaceholder()
		}

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
