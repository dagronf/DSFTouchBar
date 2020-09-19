//
//  File.swift
//
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {
	public class Button: UIElementItem<NSButton> {
		// private var _button: NSButton?

		private var _type: NSButton.ButtonType = .momentaryLight
		public func type(_ type: NSButton.ButtonType) -> Button {
			_type = type
			return self
		}

		// MARK: - Attributed Title settings

		private var _attributedTitle: NSAttributedString?
		public func attributedTitle(_ title: NSAttributedString) -> Button {
			_attributedTitle = title
			return self
		}

		// MARK: - Title settings

		private var _title = BindableBinding<String>()
		public func title(_ title: String) -> Button {
			self._title.value = title
			if let e = self.embeddedControl() {
				e.title = title
			}
			return self
		}

		public func bindTitle(to observable: AnyObject, withKeyPath keyPath: String) -> Button {
			self._title.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Alternate Title

		private var _alternateTitle: String = ""
		public func alternateTitle(_ alternateTitle: String) -> Button {
			_alternateTitle = alternateTitle
			if let e = self.embeddedControl() {
				e.alternateTitle = alternateTitle
			}
			return self
		}

		// MARK: - Button image and position

		private var _image: NSImage?
		private var _imagePosition: NSControl.ImagePosition = .imageLeading
		public func imagePosition(_ position: NSControl.ImagePosition) -> Button {
			_imagePosition = position
			if let e = self.embeddedControl() {
				e.imagePosition = position
			}
			return self
		}

		public func image(_ image: NSImage?, imagePosition: NSControl.ImagePosition = .imageLeading) -> Button {
			_image = image
			_imagePosition = imagePosition
			return self
		}

		// MARK: - Background color settings

		private var _backgroundColor = BindableAttribute<NSColor>()
		public func backgroundColor(_ value: NSColor?) -> Self {
			self._backgroundColor.value = value
			return self
		}

		public func bindBackgroundColor(to observable: AnyObject, withKeyPath keyPath: String) -> Button {
			self._backgroundColor.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Font Color

		private var _fontColor: NSColor?
		public func foregroundColor(_ color: NSColor?) -> Button {
			_fontColor = color
			return self
		}

		// MARK: - Action

		private var _action: ((NSControl.StateValue) -> Void)?
		public func action(_ action: @escaping ((NSControl.StateValue) -> Void)) -> Button {
			_action = action
			return self
		}

		// MARK: - State settings

		private let _state = BindableAttribute<NSControl.StateValue>()
		func state(_ value: NSControl.StateValue) -> Self {
			self._state.value = value
			return self
		}

		public func bindState(to observable: AnyObject, withKeyPath keyPath: String) -> Button {
			self._state.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Initializers

		public init(_ leafIdentifier: String,
					customizationLabel: String? = nil,
					type: NSButton.ButtonType = .momentaryLight)
		{
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)

			let defaultTitle = "Button"

			self._title.value = defaultTitle

			self.itemBuilder = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				let tb = NSCustomTouchBarItem(identifier: self.identifier)
				tb.customizationLabel = self._customizationLabel

				let button = NSButton(
					title: self._title.value ?? defaultTitle,
					target: self,
					action: #selector(self.act(_:))
				)

				button.translatesAutoresizingMaskIntoConstraints = false
				button.wantsLayer = true
				button.image = self._image
				button.imagePosition = self._imagePosition
				button.bezelColor = self._backgroundColor.value
				button.setButtonType(type)

				if let att = self._attributedTitle {
					button.attributedTitle = att
				}
				else if let fc = self._fontColor {
					let txtFont = button.font
					let style = NSMutableParagraphStyle()
					style.alignment = button.alignment
					let attrs: [NSAttributedString.Key: Any] = [
						.foregroundColor: fc, .paragraphStyle: style, .font: txtFont as Any,
					]
					let attrstr = NSAttributedString(string: button.title, attributes: attrs)
					button.attributedTitle = attrstr
				}

				// Build the common elements
				self.makeCommon(uiElement: button)

				// Bind the button state

				self._state.bind { [weak self] newState in
					guard let `self` = self,
						  let button = self.embeddedControl() else { return }
					button.state = newState

					if button.alternateTitle.count > 0 {
						button.title = (button.state == .on)
							? self._alternateTitle
							: self._title.value ?? "Button"
					}
				}

				// Bind the title

				self._title.bind(bindingName: NSBindingName.title, of: button)

				// Background color binding

				self._backgroundColor.bind { [weak self] newColor in
					self?.embeddedControl()?.bezelColor = newColor
				}

				tb.view = button

				return tb
			}
		}

		override func destroy() {
			self._title.unbind()
			self._state.unbind()
			self._backgroundColor.unbind()

			self._action = nil

			if let but = self.embeddedControl() {
				but.unbind(NSBindingName.value)
				but.unbind(NSBindingName.title)
				self.destroyCommon(uiElement: but)
			}

			super.destroy()
		}

		deinit {
			Swift.print("DSFTouchBar.Button(\(self.identifierString), \"\(_title)\") deinit")
		}

		@objc func act(_ sender: NSButton) {
			// If the button has an alternate title, make sure that we reflect the change in the title binding
			if let title = self._title.value,
			   _alternateTitle.count > 0
			{
				sender.title = (sender.state == .on) ? self._alternateTitle : title
			}

			/// If we have a state observer, notify that it has changed
			if let observer = self._state.bindValueObserver,
			   let keyPath = self._state.bindValueKeyPath
			{
				observer.setValue(sender.state, forKey: keyPath)
			}

			self._action?(sender.state)
		}
	}
}
