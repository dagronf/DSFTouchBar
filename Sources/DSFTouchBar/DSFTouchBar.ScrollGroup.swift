//
//  File.swift
//  
//
//  Created by Darren Ford on 4/9/20.
//

import AppKit

extension DSFTouchBar {
	public class ScrollGroup: UIElementItemBase {

		private weak var scrollView: NSScrollView?

		private(set) public var _children: [DSFTouchBar.Item] = []

		public init(_ leafIdentifier: String, _ children: [DSFTouchBar.Item]) {
			self._children = children
			super.init(leafIdentifier: leafIdentifier)

			self.maker = { [weak self] in
				return self?.make()
			}
		}

		func make() -> NSCustomTouchBarItem {

			self._children.forEach { $0.baseIdentifier = self.baseIdentifier }

			let item = NSCustomTouchBarItem(identifier: self.identifier)
			item.customizationLabel = self._customizationLabel

			let scrollView = NSScrollView()
			scrollView.hasVerticalScroller = false
			scrollView.hasHorizontalScroller = true
			item.view = scrollView

			// For simplicity, just put all the children in an hstack
			let v = NSStackView()
			v.translatesAutoresizingMaskIntoConstraints = false
			v.orientation = .horizontal
			v.distribution = .fillProportionally
			v.setHuggingPriority(.defaultLow, for: .horizontal)
			v.setHuggingPriority(.defaultLow, for: .vertical)
			v.alignment = .centerY

			scrollView.documentView = v

			scrollView.addConstraints(NSLayoutConstraint.constraints(
								withVisualFormat: "V:|[item]|",
								options: .alignAllCenterX,
								metrics: nil, views: ["item": v]))

			self._children.forEach { child in
				if let item = child.maker?() {
					guard let view = item.view else {
						Swift.print("Cannot embed '\(item.identifier.rawValue)' inside scrollgroup '\(self.identifier.rawValue)'")
						return
					}
					// If we can make the child, add it!
					v.addArrangedSubview(view)
				}
			}

			self.scrollView = scrollView

			return item
		}

		override func destroy() {
			self._children.forEach { $0.destroy() }
			self._children = []
			self.scrollView = nil
			self.scrollView?.documentView = nil
			super.destroy()
		}

		deinit {
			Swift.print("DSFTouchBar.ScrollGroup deinit")
		}
	}
}
