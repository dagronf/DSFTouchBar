//
//  DSFTouchBar.Item.swift
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
	class Item: NSObject {
		let leafIdentifier: String
		var baseIdentifier: NSTouchBarItem.Identifier? {
			didSet {
				if self.identifier == nil {
					let rv = self.baseIdentifier!.rawValue + "." + self.leafIdentifier
					self.identifier = NSTouchBarItem.Identifier(rv)
				}
			}
		}
		
		// MARK: TouchBarItem identifier
		
		private(set) var identifier: NSTouchBarItem.Identifier!
		var identifierString: String {
			return self.identifier?.rawValue ?? "<dealloced>"
		}
		
		// MARK: Customization label
		
		var _customizationLabel: String?
		public func customizationLabel(_ value: String) -> Self {
			self._customizationLabel = value
			return self
		}
		
		init(leafIdentifier: String, customizationLabel: String? = nil) {
			self.leafIdentifier = leafIdentifier
			self._customizationLabel = customizationLabel
		}
		
		init(identifier: NSTouchBarItem.Identifier) {
			self.identifier = identifier
			self.leafIdentifier = ""
		}
		
		func destroy() {
			Logging.memory(#"DSFTouchBar.Item[%@] deinit"#, args: self.identifierString)
			self.itemBuilder = nil
		}
		
		/// The block used to create the specific touchbar item
		var itemBuilder: (() -> NSTouchBarItem?)?
	}
	
	class UIElementItemBase: Item {
		//		// MARK: IsDefault
		//		var _isDefault: Bool = true
		//		private func isDefault(_ value: Bool) -> Self {
		//			_isDefault = value
		//			return self
		//		}
	}
	
	class UIElementItem<T>: UIElementItemBase where T: NSView {
		// MARK: - Control
		
		private var _control: T?
		
		/// Returns the AppKit control embedded in the touchbar item
		public func embeddedControl() -> T? { return self._control }
		
		// MARK: Create hooks
		
		private var _onCreate: ((T) -> Void)?
		
		/// Called when the toolbar item is initially created
		///
		/// Supply a block to perform any initial setup of your control
		public func onCreate(_ block: @escaping (T) -> Void) -> UIElementItem<T> {
			self._onCreate = block
			return self
		}
		
		// MARK: Destroy hooks
		
		private var _onDestroy: ((T) -> Void)?
		
		/// Called when the toolbar item is being destroyed.
		///
		/// Supply a block to clean up any custom logic you may have added
		public func onDestroy(_ block: @escaping (T) -> Void) -> UIElementItem<T> {
			self._onDestroy = block
			return self
		}
		
		// MARK: - IsHidden binding
		
		private let _hidden = BindableAttributeBinding<Bool>()
		
		/// Binding for the 'isHidden' on a touchbar item
		public func bindIsHidden<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, Bool>) -> Self {
			self._hidden.setup(observable: observable, keyPath: keyPath)
			return self
		}
		
		// MARK: - IsEnabled binding
		
		private let _enabled = BindableAttributeBinding<Bool>()
		
		/// Binding for the 'isEnabled' on a touchbar item
		public func bindIsEnabled<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, Bool>) -> Self {
			self._enabled.setup(observable: observable, keyPath: keyPath)
			return self
		}
		
		// MARK: - Width
		
		private var _width: CGFloat?
		
		/// Specify a custom width for the touchbar control
		public func width(_ width: CGFloat?) -> Self {
			self._width = width
			return self
		}
		
		// Create the common elements of this item
		func makeCommon(uiElement: T) {
			self._control = uiElement
			
			// Width
			
			if let w = self._width {
				let hconstraints = [
					NSLayoutConstraint(item: uiElement, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: w),
				]
				NSLayoutConstraint.activate(hconstraints)
			}
			
			// Enabled
			
			self._enabled.bind(bindingName: NSBindingName.enabled, of: uiElement)
			
			// Visibility
			
			self._hidden.bind(bindingName: NSBindingName.hidden, of: uiElement)
			
			// If there's a create block, call it
			self._onCreate?(uiElement)
		}
		
		func destroyCommon(uiElement: T) {
			self._hidden.unbind()
			self._enabled.unbind()
			
			self._onDestroy?(uiElement)
			
			self._onCreate = nil
			self._onDestroy = nil
			
			self._control = nil
		}
	}
}
