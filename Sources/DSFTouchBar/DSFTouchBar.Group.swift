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

		public init(_ leafIdentifier: String, equalWidths: Bool = false, _ children: [DSFTouchBar.Item]) {
			_children = children
			_equalWidths = equalWidths
			super.init(leafIdentifier: leafIdentifier)

			self.maker = { [weak self] in
				return self?.make()
			}
		}

		private func make() -> NSTouchBarItem {
			self._children.forEach { $0.baseIdentifier = self.baseIdentifier }

			let groupItems = self._children.compactMap { $0.maker?() }
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
			Swift.print("DSFTouchBar.Group(\(self.identifierString)) deinit")
		}
	}
}
