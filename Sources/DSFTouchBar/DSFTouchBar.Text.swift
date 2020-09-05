//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {
	
	public class Text: UIElementItem<NSTextField> {
		private var _label: String? = "Label"
		public func label(_ label: String) -> Text {
			_label = label
			_attributedLabel = nil
			return self
		}

		// Label observer

		private var bindObserver: AnyObject? = nil
		private var bindKeyPath: String? = nil
		public func bindLabel(to observable: AnyObject, withKeyPath keyPath: String) -> Text {
			self.bindObserver = observable
			self.bindKeyPath = keyPath
			return self
		}

		private var _attributedLabel: NSAttributedString? = nil
		public func attributedLabel(_ value: NSAttributedString) -> Text {
			_attributedLabel = value
			_label = nil
			return self
		}

		private var bindAttributedTextLabelObserver: AnyObject? = nil
		private var bindAttributedTextLabelKeyPath: String? = nil
		public func bindAttributedTextLabel(to observable: AnyObject, withKeyPath keyPath: String) -> Text {
			self.bindAttributedTextLabelObserver = observable
			self.bindAttributedTextLabelKeyPath = keyPath
			return self
		}


		public init(_ identifier: NSTouchBarItem.Identifier) {
			super.init(ident: identifier)
			
			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}
				
				let tb = NSCustomTouchBarItem(identifier: self.identifier)
				tb.customizationLabel = self._customizationLabel
				
				let field = (self._label != nil) ? NSTextField(labelWithString: self._label!)
												 : NSTextField(labelWithAttributedString: self._attributedLabel!)
				field.translatesAutoresizingMaskIntoConstraints = false
				field.alignment = .center
				tb.view = field

				// If the plain string value is bound…

				if let observer = self.bindObserver,
					let keyPath = self.bindKeyPath,
					field.exposedBindings.contains(NSBindingName.value) {
					field.bind(NSBindingName.value,
							   to: observer,
							   withKeyPath: keyPath,
							   options: nil)

					// Set the initial value from the binding if we can
					if let v = observer.value(forKeyPath: keyPath) as? String {
						field.stringValue = v
					}
				}

				// If the attributed string value is bound…

				if let observer = self.bindAttributedTextLabelObserver,
				   let keyPath = self.bindAttributedTextLabelKeyPath {
					observer.addObserver(self, forKeyPath: keyPath, options: [.new], context: nil)
					// Set the initial value from the binding if we can
					if let v = observer.value(forKeyPath: keyPath) as? NSAttributedString {
						field.attributedStringValue = v
					}
				}

				self.makeCommon(uiElement: field)
				return tb
			}
		}

		override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
			if let bindKeyPath = self.bindAttributedTextLabelKeyPath,
			   bindKeyPath == keyPath,
			   let newVal = change?[.newKey] as? NSAttributedString {
				self.embeddedControl()?.attributedStringValue = newVal
			}
			else {
				super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
			}
		}

		deinit {
			Swift.print("DSFTouchBar.Text deinit")
		}

		override func destroy() {
			if let field = self.embeddedControl() {
				field.unbind(NSBindingName.value)

				if let observer = self.bindAttributedTextLabelObserver,
				   let keyPath = self.bindAttributedTextLabelKeyPath {
					observer.removeObserver(self, forKeyPath: keyPath)
				}

				self.bindObserver = nil
				self.bindKeyPath = nil

				self.bindAttributedTextLabelKeyPath = nil
				self.bindAttributedTextLabelObserver = nil

				self.destroyCommon(uiElement: field)
			}
			super.destroy()
		}
	}
	
}
