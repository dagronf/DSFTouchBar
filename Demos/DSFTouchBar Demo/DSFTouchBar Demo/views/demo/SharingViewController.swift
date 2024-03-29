//
//  SharingViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 17/9/20.
//

import Cocoa

import DSFTouchBar

class SharingViewController: NSViewController {

	/// The image to use for sharing
	let shareImage = NSImage(named: "testimage")!
	let shareText = "Shared using the touchbar"

	/// Toggle for the sharing buttons enabled/disabled
	@objc dynamic var sharingAvailable = false

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}

	override func makeTouchBar() -> NSTouchBar? {
		let builder = DSFTouchBar(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.demo.sharing"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar.demo.sharing")) {

			// Sharing of an image

			DSFTouchBar.SharingServicePicker(DSFTouchBar.LeafIdentifier("sharey"), title: "Sharing Image")
				.bindIsEnabled(to: self, withKeyPath: \SharingViewController.sharingAvailable)
				.provideItems { [weak self] in
					guard let `self` = self else { return [] }
					return [self.shareImage]
				}

			// Sharing of text

			DSFTouchBar.SharingServicePicker(DSFTouchBar.LeafIdentifier("sharey-text"), title: "Sharing Text")
				.bindIsEnabled(to: self, withKeyPath: \SharingViewController.sharingAvailable)
				.provideItems { [weak self] in
					guard let `self` = self else { return [] }
					return [self.shareText]
				}

			DSFTouchBar.OtherItemsPlaceholder()
		}
		return builder.makeTouchBar()
	}
}

extension SharingViewController: DemoContentViewController {
	static func Create() -> NSViewController {
		return SharingViewController()
	}
	static func Title() -> String {
		return "Sharing Button"
	}

	func cleanup() {
		self.touchBar = nil
	}
}

