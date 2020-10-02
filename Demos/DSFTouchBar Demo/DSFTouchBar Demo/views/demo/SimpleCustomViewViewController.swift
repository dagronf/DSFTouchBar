//
//  SimpleCustomViewViewController.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 9/9/20.
//

import Cocoa

import DSFSparkline
import DSFTouchBar

class SimpleCustomViewViewController: NSViewController {

	var sparklineVC1 = SparkViewController()
	var sparklineVC2 = SparkViewController()
	var sparklineVC3 = SparkViewController2()
	var sparklineVC4 = SparkViewController2()

	override func viewDidLoad() {
		super.viewDidLoad()

		if let v = self.sparklineVC2.view as? DSFSparklineDotGraph {
			v.graphColor = .systemPink
			v.upsideDown = true
		}

		if let v = self.sparklineVC4.view as? DSFSparklineLineGraph {
			v.graphColor = .cyan
		}
	}

	func sparklineBar() -> DSFTouchBar.Builder {
		return DSFTouchBar.Build(
			baseIdentifier: NSTouchBarItem.Identifier("com.darrenford.touchbar.demo.custom-view"),
			customizationIdentifier: NSTouchBar.CustomizationIdentifier("com.darrenford.touchbar.demo.custom-view")) {

			DSFTouchBar.Text("label")
				.label("Sparklines ->")

			DSFTouchBar.View("sparkline1", viewController: self.sparklineVC1)
				.customizationLabel("Sparkline 1")
				.width(100)

			DSFTouchBar.View("sparkline2", viewController: self.sparklineVC2)
				.customizationLabel("Sparkline 2")
				.width(100)

			DSFTouchBar.Spacer(size: .small)

			DSFTouchBar.View("sparkline3", viewController: self.sparklineVC3)
				.customizationLabel("Sparkline 3")
				.width(75)

			DSFTouchBar.View("sparkline4", viewController: self.sparklineVC4)
				.customizationLabel("Sparkline 4")
				.width(75)

			DSFTouchBar.OtherItemsPlaceholder()
		}
	}

	override func makeTouchBar() -> NSTouchBar? {
		return sparklineBar().makeTouchBar()
	}
}


class SparkViewController: NSViewController {
	let sparklineDataSource = DSFSparklineDataSource(windowSize: 50, range: 0.0 ... 1.0)
	override func loadView() {
		let sparklineView = DSFSparklineDotGraph()
		sparklineView.windowSize = 50
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
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let `self` = self else {
				return
			}

			let cr = CGFloat.random(in: 0.0 ... 1.0)
			_ = self.sparklineDataSource.push(value: cr)
			self.updateWithNewValues()
		}
	}
}

class SparkViewController2: NSViewController {
	let sparklineDataSource = DSFSparklineDataSource(windowSize: 20, range: 0.0 ... 1.0)
	override func loadView() {
		let sparklineView = DSFSparklineLineGraph()
		sparklineView.windowSize = 20
		sparklineView.graphColor = NSColor.yellow
		sparklineView.interpolated = true
		sparklineView.showZero = false
		self.view = sparklineView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		(self.view as? DSFSparklineView)?.dataSource = sparklineDataSource

		self.updateWithNewValues()
	}

	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let `self` = self else {
				return
			}

			let cr = CGFloat.random(in: 0.0 ... 1.0)
			_ = self.sparklineDataSource.push(value: cr)
			self.updateWithNewValues()
		}
	}
}

extension SimpleCustomViewViewController: DemoContentViewController {
	static func Create() -> NSViewController {
		return SimpleCustomViewViewController()
	}

	static func Title() -> String {
		return "Simple Custom View"
	}

	func cleanup() {
		self.touchBar = nil
	}
}
