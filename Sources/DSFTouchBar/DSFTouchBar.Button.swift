//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {

	public class Button: UIElementItem<NSButton> {

		//private var _button: NSButton?

		private var _type: NSButton.ButtonType = .momentaryLight
		public func type(_ type: NSButton.ButtonType) -> Button {
			_type = type
			return self
		}


		private var _attributedTitle: NSAttributedString?
		public func attributedTitle(_ title: NSAttributedString) -> Button {
			_attributedTitle = title
			return self
		}

		private var _title: String = "Button"
		public func title(_ title: String) -> Button {
			_title = title
			return self
		}

		private var _alternateTitle: String = ""
		public func alternateTitle(_ alternateTitle: String) -> Button {
			_alternateTitle = alternateTitle
			return self
		}

		private var _image: NSImage?
		func image(_ image: NSImage?) -> Button {
			_image = image
			return self
		}

		private var _color: NSColor?
		public func color(_ color: NSColor?) -> Button {
			_color = color
			return self
		}

		private var _action: ((NSControl.StateValue) -> Void)?
		public func action(_ action: @escaping ((NSControl.StateValue) -> Void)) -> Button {
			_action = action
			return self
		}

		private var bindObserver: Any? = nil
		private var bindKeyPath: String? = nil
		public func bindState(to observable: Any, withKeyPath keyPath: String) -> Button {
			self.bindObserver = observable
			self.bindKeyPath = keyPath
			return self
		}

		public init(_ leafIdentifier: String, type: NSButton.ButtonType = .momentaryLight) { //, label: String, image: NSImage? = nil) {
			super.init(leafIdentifier: leafIdentifier)

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				let tb = NSCustomTouchBarItem(identifier: self.identifier)
				tb.customizationLabel = self._customizationLabel

				let button = NSButton(title: self._title, target: self, action: #selector(self.act(_:)))

				button.translatesAutoresizingMaskIntoConstraints = false
				button.image = self._image
				button.bezelColor = self._color
				button.setButtonType(type)

				if let att = self._attributedTitle {
					button.attributedTitle = att
				}

				// If the button type is not an 'on off' type, then the value binding doesn't
				// exist for the button.  We need to check first.
				if button.exposedBindings.contains(NSBindingName.value),
					let observer = self.bindObserver,
					let keyPath = self.bindKeyPath {
					button.bind(NSBindingName.value,
								to: observer,
								withKeyPath: keyPath,
								options: nil)
				}

				self.makeCommon(uiElement: button)
				tb.view = button

				return tb
			}
		}

		override func destroy() {
			if let but = self.embeddedControl() {
				but.unbind(NSBindingName.value)
				self.destroyCommon(uiElement: but)
			}
			self.bindObserver = nil
			self.bindKeyPath = nil
			self._action = nil
			super.destroy()
		}

		deinit {
			Swift.print("DSFTouchBar.Button deinit")
		}

		@objc func act(_ sender: NSButton) {

			if _alternateTitle.count > 0 {
				sender.title = (sender.state == .on) ? self._alternateTitle : self._title
			}

			self._action?(sender.state)
		}
	}
}
