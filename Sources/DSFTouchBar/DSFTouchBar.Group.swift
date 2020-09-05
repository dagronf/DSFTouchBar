//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {

	public class Group: UIElementItemBase {
		private(set) public var _children: [DSFTouchBar.Item] = []
		private var _equalWidths: Bool = false

		public init(_ identifier: NSTouchBarItem.Identifier, equalWidths: Bool = false, _ children: [DSFTouchBar.Item]) {
			_children = children
			_equalWidths = equalWidths
			super.init(ident: identifier)

			self.maker = { [weak self] in
				guard let `self` = self else { return nil }
				let groupItems = self._children.compactMap { $0.maker?() }
				let tb = NSGroupTouchBarItem(identifier: self.identifier, items: groupItems)
				//tb.customizationLabel = self._customizationLabel
				tb.prefersEqualWidths = self._equalWidths
				return tb
			}
		}

		override func destroy() {
			self._children.forEach { $0.destroy() }
			self._children = []
			super.destroy()
		}

		deinit {
			Swift.print("DSFTouchBar.Group deinit")
		}
	}
}
