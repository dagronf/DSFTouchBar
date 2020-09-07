//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {
	public class View: UIElementItem<NSView> {

		var viewController: NSViewController?

		public init(_ leafIdentifier: String, viewController: NSViewController) {
			self.viewController = viewController
			super.init(leafIdentifier: leafIdentifier)

			self.maker = { [weak self] in
				guard let `self` = self,
					  let vc = self.viewController else { return nil }

				let item = NSCustomTouchBarItem(identifier: self.identifier)
				item.viewController = vc
				item.customizationLabel = self._customizationLabel

				self.makeCommon(uiElement: vc.view)

				return item
			}
		}

		override func destroy() {
			if let view = self.embeddedControl() {
				self.destroyCommon(uiElement: view)
			}
			self.viewController = nil
		}

		deinit {
			Swift.print("DSFTouchBar.View deinit")
		}
	}
}
