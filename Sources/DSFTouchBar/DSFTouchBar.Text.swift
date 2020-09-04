//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {
	
	public class Text: UIElementItem<NSTextField> {
		private var _label: String? = nil
		func label(_ label: String) -> Text {
			_label = label
			return self
		}

		// Label observer

		private var bindObserver: Any? = nil
		private var bindKeyPath: String? = nil
		public func bindLabel(to observable: Any, withKeyPath keyPath: String) -> Text {
			self.bindObserver = observable
			self.bindKeyPath = keyPath
			return self
		}

		private var _attributedLabel: NSAttributedString? = nil
		func attributedLabel(_ value: NSAttributedString) -> Text {
			_attributedLabel = value
			return self
		}

		public init(identifier: NSTouchBarItem.Identifier, label: String? = nil, attributedLabel: NSAttributedString? = nil) {

			assert(label != nil || attributedLabel != nil)

			self._label = label
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
				tb.view = field

				if let observer = self.bindObserver,
					let keyPath = self.bindKeyPath,
					field.exposedBindings.contains(NSBindingName.value) {
					field.bind(NSBindingName.value,
							   to: observer,
							   withKeyPath: keyPath,
							   options: nil)
				}

				if let observer = self.bindObserver,
					let keyPath = self.bindKeyPath,
					field.exposedBindings.contains(NSBindingName.value) {
					field.bind(NSBindingName.value,
							   to: observer,
							   withKeyPath: keyPath,
							   options: nil)
				}

				self.makeCommon(uiElement: field)
				return tb
			}
		}

		deinit {
			Swift.print("DSFTouchBar.Text deinit")
		}

		override func destroy() {
			if let field = self.embeddedControl() {
				field.unbind(NSBindingName.value)
				self.destroyCommon(uiElement: field)
			}
			super.destroy()
		}
	}
	
}
