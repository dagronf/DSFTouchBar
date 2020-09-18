//
//  ScrollGroupViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 11/9/20.
//

import Cocoa

class ScrollGroupViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

	var customTouchBar: DSFTouchBar.Builder {
		DSFTouchBar.Builder(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.demo.scrollgroup"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar.demo.scrollgroup"),

			DSFTouchBar.Text("root_text").label("ScrollGroup ->"),
			DSFTouchBar.Spacer(size: .small),
			DSFTouchBar.ScrollGroup("scrollgroup", [
				DSFTouchBar.Button("button-1").title("😀1").action { state in Swift.print("1 pressed") },
				DSFTouchBar.Button("button-2").title("😀2").action { state in Swift.print("2 pressed") },
				DSFTouchBar.Button("button-3").title("😀3").action { state in Swift.print("3 pressed") },
				DSFTouchBar.Button("button-4").title("😀4").action { state in Swift.print("4 pressed") },
				DSFTouchBar.Button("button-5").title("😀5").action { state in Swift.print("5 pressed") },
				DSFTouchBar.Button("button-6").title("😀6").action { state in Swift.print("6 pressed") },
				DSFTouchBar.Button("button-7").title("😀7").action { state in Swift.print("7 pressed") },
				DSFTouchBar.Button("button-8").title("😀8").action { state in Swift.print("8 pressed") },
			]),
			DSFTouchBar.Spacer(size: .small),
			DSFTouchBar.Text("happy_smiley").label("Click!"),

			DSFTouchBar.OtherItemsPlaceholder()
		)
	}

	override func makeTouchBar() -> NSTouchBar? {
		return self.customTouchBar.makeTouchBar()
	}

}

extension ScrollGroupViewController: DemoContentViewController {
	static func Create() -> NSViewController {
		return ScrollGroupViewController()
	}
	static func Title() -> String {
		return "Scroll Group"
	}
	func cleanup() {
		self.customTouchBar.destroy()
	}
}
