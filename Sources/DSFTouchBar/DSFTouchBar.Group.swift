//
//  DSFTouchBar.Group.swift
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
	/// A item that provides a bar to contain other items.
	class Group: UIElementItemBase {
		// MARK: - Children
		
		private var _children: [DSFTouchBar.Item] = []
		
		/// Returns the child items for the group
		public var children: [DSFTouchBar.Item] {
			return self._children
		}
		
		// MARK: - Widths
		
		private var _equalWidths: Bool = false
		
		// MARK: - Initializers
		
		/// Initializer
		/// - Parameters:
		///   - leafIdentifier: the unique identifier for the toolbar item at this level
		///   - customizationLabel: The user-visible string identifying this item during bar customization.
		///   - equalWidths: Should the elements of the group maintain equal widths?
		///   - children: The child items for the group
		public init(_ leafIdentifier: String, customizationLabel: String? = nil, equalWidths: Bool = false, _ children: [DSFTouchBar.Item]) {
			self._children = children
			self._equalWidths = equalWidths
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)
			
			self.itemBuilder = { [weak self] in
				self?.buildItem()
			}
		}
		
		/// Initializer
		/// - Parameters:
		///   - leafIdentifier: the unique identifier for the toolbar item at this level
		///   - customizationLabel: The user-visible string identifying this item during bar customization.
		///   - equalWidths: Should the elements of the group maintain equal widths?
		///   - builder: The child items for the group in @resultBuilder format
		public convenience init(
			_ leafIdentifier: String,
			customizationLabel: String? = nil,
			equalWidths: Bool = false,
			@DSFTouchBarGroupBuilder builder: () -> [DSFTouchBar.Item]
		) {
			self.init(leafIdentifier,
						 customizationLabel: customizationLabel,
						 equalWidths: equalWidths,
						 builder())
		}
		
		private func buildItem() -> NSTouchBarItem {
			self._children.forEach { $0.baseIdentifier = self.baseIdentifier }
			
			let groupItems = self._children.compactMap { $0.itemBuilder?() }
			let tb = NSGroupTouchBarItem(identifier: self.identifier, items: groupItems)
			tb.customizationLabel = self._customizationLabel
			tb.prefersEqualWidths = self._equalWidths
			return tb
		}
		
		override func destroy() {
			self._children.forEach { $0.destroy() }
			self._children = []
			super.destroy()
		}
		
		deinit {
			Logging.memory(#"DSFTouchBar.Group[%@] deinit"#, args: self.identifierString)
		}
	}
}
