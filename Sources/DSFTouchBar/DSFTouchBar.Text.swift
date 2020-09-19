//
//  File.swift
//
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {
	public class Text: UIElementItem<NSTextField> {
		// MARK: - label

		private var _label = BindableBinding<String>()

		/// Set the label for the text object
		public func label(_ label: String) -> Text {
			_label.value = label
			_attributedLabel.value = nil
			return self
		}

		/// Bind the label of the text
		public func bindLabel(to observable: AnyObject, withKeyPath keyPath: String) -> Text {
			self._label.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Attributed label

		private var _attributedLabel = BindableAttribute<NSAttributedString>()

		/// Set the attributed text for the label
		public func attributedLabel(_ value: NSAttributedString) -> Text {
			_attributedLabel.value = value
			return self
		}

		public func bindAttributedTextLabel(to observable: AnyObject, withKeyPath keyPath: String) -> Text {
			self._attributedLabel.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Initialization and Configuration

		public init(_ leafIdentifier: String,
					customizationLabel: String? = nil,
					label: String? = nil) {
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)

			/// Set the label if specified
			if let label = label {
				self._label.value = label
			}

			self.itemBuilder = { [weak self] in
				self?.makeTouchbarItem()
			}
		}

		private func makeTouchbarItem() -> NSTouchBarItem? {
			let tb = NSCustomTouchBarItem(identifier: self.identifier)
			tb.customizationLabel = self._customizationLabel

			// If there's an attributed label, use it.  If not, fall back to the base label
			let field: NSTextField
			if let attributed = self._attributedLabel.value {
				field = NSTextField(labelWithAttributedString: attributed)
			}
			else if let basicLabel = self._label.value {
				field = NSTextField(labelWithString: basicLabel)
			}
			else {
				field = NSTextField(labelWithString: "Label")
			}

			field.translatesAutoresizingMaskIntoConstraints = false
			field.alignment = .center
			tb.view = field

			// Build the common elements

			self.makeCommon(uiElement: field)

			// If the plain string value is bound, bind the field value to the label
			self._label.bind(bindingName: NSBindingName.value, of: field)

			// If the attributed string value is bound…
			self._attributedLabel.bind { [weak self] (value) -> (Void) in
				self?.embeddedControl()?.attributedStringValue = value
			}

			return tb
		}

		deinit {
			Swift.print("DSFTouchBar.Text(\(self.identifierString), \"\(_label.value)\") deinit")
		}

		override func destroy() {
			if let field = self.embeddedControl() {
				field.unbind(NSBindingName.value)

				// If there were bindings to the label, remove them
				self._label.unbind()

				// If there were bindings to the attributed label, remove them
				self._attributedLabel.unbind()

				// And destroy the common elements
				self.destroyCommon(uiElement: field)
			}
			super.destroy()
		}
	}
}
