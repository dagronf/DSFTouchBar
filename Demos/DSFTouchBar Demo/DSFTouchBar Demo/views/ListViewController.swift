//
//  ListViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 7/9/20.
//

import Cocoa

let DemoListItemSelectedChangedNotification = Notification.Name("DemoListItemSelectedChangedNotification")

class ListViewController: NSViewController {

	@IBOutlet weak var listTableView: NSTableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.

		NotificationCenter.default.addObserver(
			forName: DemoViewControllerDidChangeNotification,
			object: DemoContent,
			queue: OperationQueue.main) { notification in
			if let vc = notification.userInfo?["vc"] as? NSViewController {
				self.viewControllerDidChange(vc)
			}
		}

	}

	deinit {
		if #available(OSX 10.12.2, *) {
			unbind(NSBindingName(rawValue: #keyPath(touchBar)))
		}
	}
}

extension ListViewController: NSTableViewDataSource, NSTableViewDelegate {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return DemoContent.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let v = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("ListItem"), owner: self) as? NSTableCellView else {
			assert(false)
			return nil
		}

		v.textField?.stringValue = DemoContent.allNames[row]
		return v
	}

	func tableViewSelectionDidChange(_ notification: Notification) {
		let row = self.listTableView.selectedRow

		unbind(NSBindingName(rawValue: #keyPath(touchBar))) // unbind first
		self.touchBar = nil

		var name = ""
		if row != -1 {
			name = DemoContent.allNames[row]
		}
		
		NotificationCenter.default.post(
			name: DemoListItemSelectedChangedNotification,
			object: DemoContent,
			userInfo: ["named": name])
	}

	/**
		Taken From NSTouchBar Catalog code
		https://developer.apple.com/documentation/appkit/touch_bar/creating_and_customizing_the_touch_bar

		Bind the NSTouchBar instance of master view controller to the one of the detal view controller
		so that the bar always shows up whoever the first responder is.
	*/

	func viewControllerDidChange(_ viewController: NSViewController) {
		if #available(OSX 10.12.2, *) {
			bind(NSBindingName(rawValue: #keyPath(touchBar)), to: viewController, withKeyPath: #keyPath(touchBar), options: nil)
		}
	}
}
