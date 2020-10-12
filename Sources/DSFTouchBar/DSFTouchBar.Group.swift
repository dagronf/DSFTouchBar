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

extension DSFTouchBar {
	public class Group: UIElementItemBase {
		public private(set) var _children: [DSFTouchBar.Item] = []
		private var _equalWidths: Bool = false
		
		public init(_ leafIdentifier: String, customizationLabel: String? = nil, equalWidths: Bool = false, _ children: [DSFTouchBar.Item]) {
			_children = children
			_equalWidths = equalWidths
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)
			
			self.itemBuilder = { [weak self] in
				self?.buildItem()
			}
		}
		
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
