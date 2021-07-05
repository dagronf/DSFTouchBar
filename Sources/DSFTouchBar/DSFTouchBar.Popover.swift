//
//  DSFTouchBar.Popover.swift
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

public extension DSFTouchBar {
	/// A pop
	class Popover: UIElementItemBase {
		private var popoverContentBuilder: DSFTouchBar?

		// Cleanup handle
		private var AssociatedObjectHandle: UInt8 = 0

		private var _children: [DSFTouchBar.Item] = []

		/// Returns the child items for the group
		public var children: [DSFTouchBar.Item] {
			return self._children
		}

		/// Initializer
		/// - Parameters:
		///   - leafIdentifier: the unique identifier for the toolbar item at this level
		///   - collapsedLabel: the label to display when the popover content isn't visible
		///   - collapsedImage: the image to display when the popover content isn't visible
		///   - children: The child items for the group
		public init(_ leafIdentifier: LeafIdentifier,
						collapsedLabel: String? = nil,
						collapsedImage: NSImage? = nil,
						_ children: [DSFTouchBar.Item])
		{
			self._children = children
			super.init(leafIdentifier: leafIdentifier)

			self.itemBuilder = { [weak self] in
				self?.makeTouchbarItem(collapsedLabel: collapsedLabel, collapsedImage: collapsedImage)
			}
		}

		/// Initializer
		/// - Parameters:
		///   - leafIdentifier: the unique identifier for the toolbar item at this level
		///   - collapsedLabel: the label to display when the popover content isn't visible
		///   - collapsedImage: the image to display when the popover content isn't visible
		///   - builder: The child items for the group in @resultBuilder format
		public convenience init(
			_ leafIdentifier: LeafIdentifier,
			collapsedLabel: String? = nil,
			collapsedImage: NSImage? = nil,
			@DSFTouchBarScrollPopoverBuilder builder: () -> [DSFTouchBar.Item]
		) {
			self.init(leafIdentifier,
						 collapsedLabel: collapsedLabel,
						 collapsedImage: collapsedImage,
						 builder())
		}

		override func destroy() {
			self.popoverContentBuilder?.destroy()
			self.popoverContentBuilder = nil
			super.destroy()
		}

		deinit {
			Logging.memory(#"DSFTouchBar.Popover[%@] deinit"#, args: self.identifierString)
		}
	}
}

// MARK: Make touchbar item

extension DSFTouchBar.Popover {
	private func makeTouchbarItem(collapsedLabel: String?, collapsedImage: NSImage?) -> NSTouchBarItem? {
		self.popoverContentBuilder = nil

		let rc = self.baseIdentifier!.rawValue + "." + self.leafIdentifier.rawValue
		let pc = DSFTouchBar(baseIdentifier: NSTouchBarItem.Identifier(rc))

		for item in self._children {
			pc.add(item: item)
		}

		let tb = NSPopoverTouchBarItem(identifier: self.identifier)
		tb.customizationLabel = self._customizationLabel

		if let label = collapsedLabel {
			tb.collapsedRepresentationLabel = label
		}
		tb.collapsedRepresentationImage = collapsedImage

		if let mtb = pc.makeTouchBar() {
			tb.pressAndHoldTouchBar = mtb
			tb.popoverTouchBar = mtb
		}

		// Tie the lifecycle of the DSFToolbar object to the lifecycle of the nstoolbar
		// so that we don't have to manually destroy it
		objc_setAssociatedObject(tb, &self.AssociatedObjectHandle, pc, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

		self.popoverContentBuilder = pc

		self._children = []

		return tb
	}
}
