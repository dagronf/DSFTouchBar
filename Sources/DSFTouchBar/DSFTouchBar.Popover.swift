//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {
	public class Popover: UIElementItemBase {

		private var popoverContent: DSFTouchBar? = nil

		private(set) var _children: [DSFTouchBar.Item] = []
		public init(_ identifier: NSTouchBarItem.Identifier,
			 collapsedLabel: String? = nil,
			 collapsedImage: NSImage? = nil,
			 _ children: [DSFTouchBar.Item]) {
			_children = children
			super.init(ident: identifier)

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				self.popoverContent = nil
				let pc = DSFTouchBar()

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

				self.popoverContent = pc

				return tb
			}
		}
	}
}
