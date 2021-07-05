//
//  ViewController.swift
//  Documentation Demo
//
//  Created by Darren Ford on 1/7/21.
//

import Cocoa

import DSFTouchBar

class FocusView: NSView {
	override var acceptsFirstResponder: Bool { return true }
}

class ViewController: NSViewController {

	@objc dynamic var editBackgroundColor: NSColor = .clear
	@objc dynamic var editbutton_state: NSButton.StateValue = .off {
		didSet {
			Swift.print("Edit Button - STATE CHANGE - \(editbutton_state)")
			self.canEdit = (editbutton_state == .on)
			self.editBackgroundColor = self.canEdit ? .systemYellow : .clear
		}
	}

	@objc dynamic var upgradeBackgroundColor: NSColor = .clear
	@objc dynamic var canEdit: Bool = false {
		didSet {
			self.upgradeBackgroundColor = canEdit ? .systemPurple : .clear
		}
	}


	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
}

extension ViewController {
	override func makeTouchBar() -> NSTouchBar? {
		DSFTouchBar(
			baseIdentifier: .init("com.darrenford.dsftouchbar.documentation"),
			customizationIdentifier: .init("com.darrenford.dsftouchbar.documentation.docodemo")) {

			// This button will have the unique identifier 'com.darrenford.dsftouchbar.documentation.edit-document'
			DSFTouchBar.Button(.init("edit-document"), customizationLabel: "Edit Document")
				.title("Edit")
				.type(.onOff)
				.bindState(to: self, withKeyPath: \ViewController.editbutton_state)
				.bindBackgroundColor(to: self, withKeyPath: \ViewController.editBackgroundColor)
				.action { _ in
					Swift.print("Edit button pressed")
				}

			// This button will have the unique identifier 'com.darrenford.dsftouchbar.documentation.upgrade-document'
			DSFTouchBar.Button(.init("upgrade-document"), customizationLabel: "Upgrade Document")
				.title("Upgrade")
				.bindIsEnabled(to: self, withKeyPath: \ViewController.canEdit)
				.bindBackgroundColor(to: self, withKeyPath: \ViewController.upgradeBackgroundColor)
				.action { _ in
					Swift.print("Upgrade button pressed")
				}

			// This button will have the unique identifier 'com.darrenford.dsftouchbar.documentation.go-document'
			DSFTouchBar.Button(.init("go-button"), customizationLabel: "Go Somewhere")
				.title("Go")
				.image(NSImage(named: NSImage.touchBarGoForwardTemplateName))
				.imagePosition(.imageRight)
				.action { state in
					Swift.print("GO!")
				}

			DSFTouchBar.OtherItemsPlaceholder()
		}
		.makeTouchBar()
	}
}
