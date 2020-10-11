//
//  DSFTouchBar.Button.swift
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

extension DSFTouchBar {
	public class Button: UIElementItem<NSButton> {
		// private var _button: NSButton?

		private var _type: NSButton.ButtonType = .momentaryLight

		/// Set the button type for the button
		public func type(_ type: NSButton.ButtonType) -> Button {
			_type = type
			if let e = self.embeddedControl() {
				e.setButtonType(type)
			}
			return self
		}

		// MARK: - Attributed Title settings

		private var _attributedTitle: NSAttributedString?

		/// Set the attributed (styled) title for the button
		public func attributedTitle(_ title: NSAttributedString) -> Button {
			_attributedTitle = title
			if let e = self.embeddedControl() {
				e.attributedTitle = title
			}
			return self
		}

		// MARK: - Title settings

		private var _title = BindableAttributeBinding<String>()

		/// Set the title
		/// - Parameter title: The title for the button
		/// - Returns: self
		public func title(_ title: String) -> Button {
			self._title.value = title
			if let e = self.embeddedControl() {
				e.title = title
			}
			return self
		}

		/// Bind the title for the button to an observer
		/// - Parameters:
		///   - observable: The observing object
		///   - keyPath: The key path to the member variable to observe
		/// - Returns: self
		@discardableResult
		public func bindTitle<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, String>) -> Button {
			self._title.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Alternate Title

		private var _alternateTitle: String = ""

		/// Set the alternative title (the title displayed when 'on')
		/// - Parameter alternateTitle: The alternative title
		/// - Returns: self
		@discardableResult
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

		/// Set the position for the image on the button
		/// - Parameter position: the position
		/// - Returns: self
		public func imagePosition(_ position: NSControl.ImagePosition) -> Button {
			_imagePosition = position
			if let e = self.embeddedControl() {
				e.imagePosition = position
			}
			return self
		}

		/// Set the image and image position for the button
		/// - Parameters:
		///   - image: the image to display
		///   - imagePosition: the position on the button to display the image
		/// - Returns: self
		public func image(_ image: NSImage?, imagePosition: NSControl.ImagePosition = .imageLeading) -> Button {
			_image = image
			_imagePosition = imagePosition
			if let e = self.embeddedControl() {
				e.image = image
				e.imagePosition = imagePosition
			}
			return self
		}

		// MARK: - Background color settings

		private var _backgroundColor = BindableTypedAttribute<NSColor>()

		/// Set the background color for the button
		public func backgroundColor(_ value: NSColor?) -> Self {
			self._backgroundColor.value = value
			return self
		}

		/// Bind the background color of the button to an observable
		/// - Parameters:
		///   - observable: The object to observe
		///   - keyPath: The key path of the member variable to observe
		/// - Returns: self
		public func bindBackgroundColor<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, NSColor>) -> Button {
			self._backgroundColor.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Font Color

		private var _fontColor: NSColor?

		/// Set the foreground color to use for the text on the button
		public func foregroundColor(_ color: NSColor?) -> Button {
			_fontColor = color
			return self
		}

		// MARK: - Action

		private var _action: ((NSControl.StateValue) -> Void)?

		/// Set the action callback block
		/// - Parameter action: the action block to perform
		/// - Returns: self
		public func action(_ action: @escaping ((NSControl.StateValue) -> Void)) -> Button {
			_action = action
			return self
		}

		// MARK: - State settings

		private let _state = BindableTypedAttribute<NSControl.StateValue>()

		/// Set the state for the button
		func state(_ value: NSControl.StateValue) -> Self {
			self._state.value = value
			return self
		}

		/// Bind the state to an observable key path
		/// - Parameters:
		///   - observable: The object to observe
		///   - keyPath: The key path for the member variable in the observable object
		/// - Returns: self
		public func bindState<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, NSControl.StateValue>) -> Button {
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

				button.alternateTitle = self._alternateTitle

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

		@objc private func act(_ sender: NSButton) {
			// If the button has an alternate title, make sure that we reflect the change in the title binding
			if let title = self._title.value, _alternateTitle.count > 0 {
				sender.title = (sender.state == .on) ? self._alternateTitle : title
			}

			// If we have a state observer, notify that it has changed
			self._state.updateValue(sender.state)

			// Any call the action
			self._action?(sender.state)
		}

		// MARK: - Cleanup and destroy

		override func destroy() {
			self._title.unbind()
			self._state.unbind()
			self._backgroundColor.unbind()

			self._action = nil

			if let but = self.embeddedControl() {
				self.destroyCommon(uiElement: but)
			}

			super.destroy()
		}

		deinit {
			Logging.memory(#"DSFTouchBar.Button[%@] deinit"#, args: self.identifierString)
		}
	}
}
