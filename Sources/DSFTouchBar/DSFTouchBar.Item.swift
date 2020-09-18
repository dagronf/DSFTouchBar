//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

public extension DSFTouchBar {
	class Item: NSObject {
		let leafIdentifier: String
		var baseIdentifier: NSTouchBarItem.Identifier? = nil {
			didSet {
				if self.identifier == nil {
					let rv = baseIdentifier!.rawValue + "." + leafIdentifier
					self.identifier = NSTouchBarItem.Identifier(rv)
				}
			}
		}
		private(set) var identifier: NSTouchBarItem.Identifier!
		var identifierString: String {
			return self.identifier?.rawValue ?? "<dealloced>"
		}

		init(leafIdentifier: String) {
			self.leafIdentifier = leafIdentifier
		}

		init(identifier: NSTouchBarItem.Identifier) {
			self.identifier = identifier
			self.leafIdentifier = ""
		}

		func destroy() {
			self.maker = nil
		}

		var maker: (() -> NSTouchBarItem?)?
	}

	class UIElementItemBase: Item {
		var _isDefault: Bool = true
		public func `default`(_ value: Bool) -> Self {
			_isDefault = value
			return self
		}

		var _customizationLabel: String?
		public func customizationLabel(_ value: String) -> Self {
			_customizationLabel = value
			return self
		}
	}

	class UIElementItem<T>: UIElementItemBase where T: NSView {
		private var _control: T?
		public func embeddedControl() -> T? { return _control }

		private var _onCreate: ((T) -> Void)?
		public func onCreate(_ block: @escaping (T) -> Void) -> UIElementItem<T> {
			_onCreate = block
			return self
		}

		private var _onDestroy: ((T) -> Void)?
		public func onDestroy(_ block: @escaping (T) -> Void) -> UIElementItem<T> {
			_onDestroy = block
			return self
		}

		private let _hidden = BindableBinding<Bool>()
		public func bindIsHidden(to observable: AnyObject, withKeyPath keyPath: String) -> Self {
			self._hidden.setup(observable: observable, keyPath: keyPath)
			return self
		}

		private let _enabled = BindableBinding<Bool>()
		public func bindIsEnabled(to observable: AnyObject, withKeyPath keyPath: String) -> Self {
			self._enabled.setup(observable: observable, keyPath: keyPath)
			return self
		}

		private var _width: CGFloat?
		public func width(_ width: CGFloat?) -> Self {
			_width = width
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
			//uiElement.unbind(NSBindingName.enabled)
			//uiElement.unbind(NSBindingName.visible)

			self._hidden.unbind()
			self._enabled.unbind()

			self._onDestroy?(uiElement)

			self._onCreate = nil
			self._onDestroy = nil

			self._control = nil
		}
	}
}
