//
//  DSFTouchBar.View.swift
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
	/// Provide a view to be displayed on a touchbar item
	class View: UIElementItem<NSView> {
		private var viewController: NSViewController?
		
		/// Create a new sharing button in the toolbar.
		/// - Parameters:
		///   - leafIdentifier: The leaf identifier for the share item. Must be unique within the current toolbar
		///   - viewController: The view controller managing the view to be displayed in the touchbar item
		public init(_ leafIdentifier: LeafIdentifier, viewController: NSViewController) {
			self.viewController = viewController
			super.init(leafIdentifier: leafIdentifier)
			
			self.itemBuilder = { [weak self] in
				guard let `self` = self,
						let vc = self.viewController else { return nil }
				
				let item = NSCustomTouchBarItem(identifier: self.identifier)
				item.viewController = vc
				item.customizationLabel = self._customizationLabel
				
				// Build the common elements
				
				self.makeCommon(uiElement: vc.view)
				
				return item
			}
		}
		
		override func destroy() {
			if let view = self.embeddedControl {
				self.destroyCommon(uiElement: view)
			}
			self.viewController = nil
		}
		
		deinit {
			Logging.memory(#"DSFTouchBar.View[%@] deinit"#, args: self.identifierString)
		}
	}
}
