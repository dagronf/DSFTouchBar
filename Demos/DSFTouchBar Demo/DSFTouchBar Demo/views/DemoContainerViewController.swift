//
//  DemoContainerViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 7/9/20.
//

import Cocoa

let DemoViewControllerDidChangeNotification = Notification.Name("DemoViewControllerDidChangeNotification")

class DemoContainerViewController: NSViewController {
	var current: NSViewController?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.

		NotificationCenter.default.addObserver(
			forName: DemoListItemSelectedChangedNotification,
			object: DemoContent,
			queue: OperationQueue.main
		) { [weak self] notification in
			if let name = notification.userInfo?["named"] as? String {
				self?.selectedName(name: name)
			}
		}
	}

	func selectedName(name: String) {
		if let c = current {
			c.view.removeFromSuperview()
			if let c = c as? DemoContentViewController {
				c.cleanup()
			}
		}
		current = nil

		guard let c = DemoContent.controller(for: name) else {
			return
		}

		self.current = c

		self.view.addSubview(c.view)
		c.view.frame = self.view.bounds

		self.view.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|[item]|",
			options: .alignAllCenterX,
			metrics: nil, views: ["item": c.view]
		))
		self.view.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|[item]|",
			options: .alignAllCenterY,
			metrics: nil, views: ["item": c.view]
		))

		NotificationCenter.default.post(
			name: DemoViewControllerDidChangeNotification,
			object: DemoContent, userInfo: ["vc": c]
		)
	}
}
