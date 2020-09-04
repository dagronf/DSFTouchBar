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

		private var groupItems: DSFTouchBar.Group?

		public init(_ identifier: NSTouchBarItem.Identifier,
					_ group: DSFTouchBar.Group) {
			self.groupItems = group
			super.init(ident: identifier)

			self.maker = { [weak self] in
				return self?.make()
			}
		}

		func make() -> NSCustomTouchBarItem {
			let item = NSCustomTouchBarItem(identifier: self.identifier)
			item.customizationLabel = self._customizationLabel

			let scrollView = NSScrollView()
			scrollView.hasVerticalScroller = false
			scrollView.hasHorizontalScroller = true
			item.view = scrollView

			let groupI = self.groupItems!.maker!()
			scrollView.documentView = groupI?.view

			self.scrollView = scrollView

			return item
		}

		deinit {
		}
	}
}
