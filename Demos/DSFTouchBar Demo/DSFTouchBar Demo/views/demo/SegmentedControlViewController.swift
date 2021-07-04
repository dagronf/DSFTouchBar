//
//  SegmentedControlViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 9/9/20.
//

import Cocoa

import DSFTouchBar

class SegmentedControlViewController: NSViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}

	@objc dynamic var segmented_1 = NSIndexSet() {
		didSet {
			Swift.print("Segment 1 -> \(segmented_1)")
		}
	}

	@objc dynamic var segmented_2 = NSIndexSet() {
		didSet {
			Swift.print("Segment 2 -> \(segmented_2)")
		}
	}

	override func makeTouchBar() -> NSTouchBar? {
		let builder = DSFTouchBar(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.demo.segmented"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar.demo.segmented")) {

			DSFTouchBar.Label("segment-single").label("Single ->")
			
			DSFTouchBar.Segmented("segmented-1", trackingMode: .selectOne)
				.add(label: "low", image: NSImage(named: NSImage.touchBarAudioOutputVolumeLowTemplateName))
				.add(label: "med", image: NSImage(named: NSImage.touchBarAudioOutputVolumeMediumTemplateName))
				.add(label: "high", image: NSImage(named: NSImage.touchBarAudioOutputVolumeHighTemplateName))
				.bindSelection(to: self, withKeyPath: \SegmentedControlViewController.segmented_1)

			DSFTouchBar.Spacer(size: .small)

			DSFTouchBar.Label("segment-multi").label("Multi ->")

			DSFTouchBar.Segmented("segmented-2", trackingMode: .selectAny)
				.add(label: "one")
				.add(label: "two")
				.add(label: "three")
				.bindSelection(to: self, withKeyPath: \SegmentedControlViewController.segmented_2)
				.selectedColor(.systemYellow)

			DSFTouchBar.OtherItemsPlaceholder()
		}

		return builder.makeTouchBar()
	}

	@IBAction func reset1(_: Any) {
		self.segmented_1 = NSIndexSet([1, 2])
	}

	@IBAction func reset2(_: Any) {
		self.segmented_2 = NSIndexSet([0, 2])
	}
}

extension SegmentedControlViewController: DemoContentViewController {
	static func Create() -> NSViewController {
		return SegmentedControlViewController()
	}

	static func Title() -> String {
		return "Segmented Controls"
	}

	func cleanup() {
		self.touchBar = nil
	}
}
