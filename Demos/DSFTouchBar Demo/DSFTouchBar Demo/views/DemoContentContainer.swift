//
//  DemoContentContainer.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 10/9/20.
//

import AppKit

let DemoContent = DemoContentContainer()

protocol DemoContentViewController {
	static func Create() -> NSViewController
	static func Title() -> String
	func cleanup()
}

class DemoContentContainer {

	var allContent = [(String, DemoContentViewController.Type)]()

	var count: Int {
		return allContent.count
	}

	var allNames: [String] {
		return allContent.map { $0.0 }
	}

	init() {
		self.setup()
	}

	func add<T>(_ item: T.Type) where T: DemoContentViewController {
		self.allContent.append( (T.Title(), T.self) )
	}

	func setup() {
		self.add(ButtonsViewController.self)
		self.add(TextViewController.self)
		self.add(SliderViewController.self)
		self.add(ColorViewController.self)
		self.add(SegmentedControlViewController.self)
		self.add(SimpleCustomViewViewController.self)
		self.add(ScrollGroupViewController.self)
		self.add(PopoverViewController.self)
		self.add(SharingViewController.self)

		self.allContent.sort { (l1, r1) -> Bool in
			return l1.0 < r1.0
		}
	}

	func controller(for title: String) -> NSViewController? {
		guard let item = allContent.filter({ $0.0 == title }).first else {
			return nil
		}
		return item.1.Create()
	}

}
