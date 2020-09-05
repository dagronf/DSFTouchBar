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
		func onCreate(_ block: @escaping (T) -> Void) -> UIElementItem<T> {
			_onCreate = block
			return self
		}

		private var _onDestroy: ((T) -> Void)?
		func onDestroy(_ block: @escaping (T) -> Void) -> UIElementItem<T> {
			_onDestroy = block
			return self
		}

		private var bindVisibilityObserver: Any?
		private var bindVisibilityKeyPath: String?
		func bindVisibility(to observable: Any, withKeyPath keyPath: String) -> Self {
			self.bindVisibilityObserver = observable
			self.bindVisibilityKeyPath = keyPath
			return self
		}

		private var bindEnabledObserver: Any?
		private var bindEnabledKeyPath: String?
		func bindEnabled(to observable: Any, withKeyPath keyPath: String) -> Self {
			self.bindEnabledObserver = observable
			self.bindEnabledKeyPath = keyPath
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

			if uiElement.exposedBindings.contains(NSBindingName.enabled),
				let observer = self.bindEnabledObserver,
				let keyPath = self.bindEnabledKeyPath {
				uiElement.bind(NSBindingName.enabled,
							   to: observer,
							   withKeyPath: keyPath,
							   options: nil)
			}

			// Visibility

			if uiElement.exposedBindings.contains(NSBindingName.visible),
				let observer = self.bindVisibilityObserver,
				let keyPath = self.bindVisibilityKeyPath {
				uiElement.bind(NSBindingName.visible,
							   to: observer,
							   withKeyPath: keyPath,
							   options: nil)
			}

			if let contr = self._onCreate {
				contr(uiElement)
			}
		}

		func destroyCommon(uiElement: T) {
			uiElement.unbind(NSBindingName.enabled)
			uiElement.unbind(NSBindingName.visible)
			if let destroyCallback = self._onDestroy {
				destroyCallback(uiElement)
			}

			self.bindEnabledObserver = nil
			self.bindVisibilityObserver = nil

			self._onCreate = nil
			self._onDestroy = nil

			self._control = nil
		}
	}
}
