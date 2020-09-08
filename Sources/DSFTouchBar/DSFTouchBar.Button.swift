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

		private var bindTitleObserver: AnyObject? = nil
		private var bindTitleKeyPath: String? = nil
		public func bindTitle(to observable: AnyObject, withKeyPath keyPath: String) -> Button {
			self.bindTitleObserver = observable
			self.bindTitleKeyPath = keyPath
			return self
		}

		private var _alternateTitle: String = ""
		public func alternateTitle(_ alternateTitle: String) -> Button {
			_alternateTitle = alternateTitle
			return self
		}

		private var _image: NSImage?
		private var _imagePosition: NSControl.ImagePosition = .imageLeading

		public func image(_ image: NSImage?, imagePosition: NSControl.ImagePosition = .imageLeading) -> Button {
			_image = image
			_imagePosition = imagePosition
			return self
		}

		private var _color: NSColor?
		public func color(_ color: NSColor?) -> Button {
			_color = color
			return self
		}

		private var bindBackgroundColorObserver: AnyObject? = nil
		private var bindBackgroundColorKeyPath: String? = nil
		public func bindBackgroundColor(to observable: AnyObject, withKeyPath keyPath: String) -> Button {
			self.bindBackgroundColorObserver = observable
			self.bindBackgroundColorKeyPath = keyPath
			return self
		}

		private var _fontColor: NSColor?
		public func foregroundColor(_ color: NSColor?) -> Button {
			_fontColor = color
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
				button.imagePosition = self._imagePosition
				button.bezelColor = self._color
				button.setButtonType(type)

				if let att = self._attributedTitle {
					button.attributedTitle = att
				}
				else if let fc = self._fontColor {
					let txtFont = button.font
					let style = NSMutableParagraphStyle()
					style.alignment = button.alignment
					let attrs: [NSAttributedString.Key: Any] = [
						.foregroundColor: fc, .paragraphStyle: style, .font: txtFont as Any
					]
					let attrstr = NSAttributedString(string: button.title, attributes: attrs)
					button.attributedTitle = attrstr
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

				if button.exposedBindings.contains(NSBindingName.title),
					let observer = self.bindTitleObserver,
					let keyPath = self.bindTitleKeyPath {
					button.bind(NSBindingName.title,
								to: observer,
								withKeyPath: keyPath,
								options: nil)
				}

				if let observer = self.bindBackgroundColorObserver,
				   let keyPath = self.bindBackgroundColorKeyPath {
					observer.addObserver(self, forKeyPath: keyPath, options: [.new], context: nil)
					// Set the initial value from the binding if we can
					if let v = observer.value(forKeyPath: keyPath) as? NSColor {
						button.bezelColor = v
					}
				}

				self.makeCommon(uiElement: button)
				tb.view = button

				return tb
			}
		}

		override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
			if let bindKeyPath = self.bindBackgroundColorKeyPath,
			   bindKeyPath == keyPath,
			   let newVal = change?[.newKey] as? NSColor {
				self.embeddedControl()?.bezelColor = newVal
			}
			else {
				super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
			}
		}

		override func destroy() {

			if let observer = self.bindBackgroundColorObserver,
			   let keyPath = self.bindBackgroundColorKeyPath {
				observer.removeObserver(self, forKeyPath: keyPath)
			}

			self.bindBackgroundColorObserver = nil
			self.bindBackgroundColorKeyPath = nil
			self.bindObserver = nil
			self.bindKeyPath = nil
			self._action = nil

			if let but = self.embeddedControl() {
				but.unbind(NSBindingName.value)
				but.unbind(NSBindingName.title)
				self.destroyCommon(uiElement: but)
			}

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
