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

		public init(_ identifier: NSTouchBarItem.Identifier, viewController: NSViewController) {
			self.viewController = viewController
			super.init(ident: identifier)

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

		deinit {
			if let view = self._control {
				self.destroyCommon(uiElement: view)
				self._control = nil
			}
		}
	}
}
