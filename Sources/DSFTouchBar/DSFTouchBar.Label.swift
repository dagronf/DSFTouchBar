//
//  DSFTouchBar.Label.swift
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

	/// A TouchBar label, with either a standard or attributed string
	///
	/// ```swift
	/// // A simple text label
	/// DSFTouchBar.Label("User")
	///    .label("User")
	///
	/// // An attributed label bound to a NSAttributedString keyPath
	/// DSFTouchBar.Label("username", customizationLabel: "User's name")
	///    .bindAttributedTextLabel(to: self, withKeyPath: \MyViewController.myLabel)
	/// ```
	///
	public class Label: UIElementItem<NSTextField> {
		// MARK: - label

		private var _label = BindableAttributeBinding<String>()

		/// Set the label for the text object
		public func label(_ label: String) -> Label {
			_label.value = label
			_attributedLabel.value = nil
			return self
		}

		/// Bind the label of the text
		///
		/// ```swift
		/// @objc dynamic var myString = String("Text")
		///    ...
		/// DSFTouchBar.Label("label", customizationLabel: "Label Text")
		///    .bindLabel(to: self, withKeyPath: \MyViewController.myString)
		/// ```
		public func bindLabel<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, String>) -> Label {
			self._label.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Attributed label

		private var _attributedLabel = BindableTypedAttribute<NSAttributedString>()

		/// Set the attributed text for the label
		public func attributedLabel(_ value: NSAttributedString) -> Label {
			_attributedLabel.value = value
			return self
		}

		/// Bind the attributed label for the item to a key path
		///
		/// ```swift
		/// @objc dynamic var simpleAttributedString = NSAttributedString(...)
		///    ...
		/// DSFTouchBar.Label("attributed", customizationLabel: "Attributed Label Text")
		///    .bindAttributedLabel(to: self, withKeyPath: \MyViewController.simpleAttributedString)
		/// ```
		public func bindAttributedLabel<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, NSAttributedString>) -> Label {
			self._attributedLabel.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Initialization and Configuration

		/// Initializer
		/// - Parameters:
		///   - leafIdentifier: the unique identifier for the toolbar item at this level
		///   - customizationLabel: The user-visible string identifying this item during bar customization.
		///   - type: The basic label, or nil for no label
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

		deinit {
			Logging.memory(#"DSFTouchBar.Text[%@] deinit"#, args: self.identifierString)
		}

		override func destroy() {
			if let field = self.embeddedControl {
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

extension DSFTouchBar.Label {
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
			self?.embeddedControl?.attributedStringValue = value
		}

		return tb
	}
}
