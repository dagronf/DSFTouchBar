//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {
	public class View: UIElementItem<NSView> {

		weak var viewController: NSViewController?

		public init(_ leafIdentifier: String, viewController: NSViewController) {
			self.viewController = viewController
			super.init(leafIdentifier: leafIdentifier)

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				guard let vc = self.viewController else {
					return nil
				}

				let item = NSCustomTouchBarItem(identifier: self.identifier)
				item.viewController = vc
				item.customizationLabel = self._customizationLabel

				self.makeCommon(uiElement: vc.view)

				return item
			}
		}

		override func destroy() {
			self.viewController = nil
			if let view = self.embeddedControl() {
				self.destroyCommon(uiElement: view)
			}
		}

		deinit {
			Swift.print("DSFTouchBar.View deinit")
		}
	}
}
