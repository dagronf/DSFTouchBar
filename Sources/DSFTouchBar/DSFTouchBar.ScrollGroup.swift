//
//  DSFTouchBar.ScrollGroup.swift
//  DSFTouchBar
//
//  Created by Darren Ford on 2/10/20.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import AppKit

extension DSFTouchBar {
	public class ScrollGroup: UIElementItemBase {

		private weak var scrollView: NSScrollView?

		private(set) public var _children: [DSFTouchBar.Item] = []

		public init(_ leafIdentifier: String,
					customizationLabel: String? = nil,
					_ children: [DSFTouchBar.Item]) {
			self._children = children
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)

			self.itemBuilder = { [weak self] in
				return self?.buildItem()
			}
		}

		func buildItem() -> NSCustomTouchBarItem {

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
				if let item = child.itemBuilder?() {
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
			Logging.memory(#"DSFTouchBar.ScrollGroup[%@] deinit"#, args: self.identifierString)
		}
	}
}
