//
//  DSFTouchBar.Slider.swift
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

public extension DSFTouchBar {
	/// A slider touchbar item
	class Slider: UIElementItem<NSSlider> {
		private weak var sliderTouchBarItem: NSSliderTouchBarItem?

		// MARK: - Action

		private var _action: ((CGFloat) -> Void)?

		/// Supply a callback for when the slider changes value
		public func action(_ action: @escaping ((CGFloat) -> Void)) -> Slider {
			self._action = action
			return self
		}

		// MARK: - Slider label

		private var _label: String?
		
		/// Set the label for the slider
		public func label(_ label: String) -> Slider {
			self._label = label
			return self
		}

		// MARK: - Accessory label (MIN)

		private var _minAccessoryImage: NSImage?

		/// Set the image to be displayed for the minimum end of the slider
		@discardableResult public func minimumValueAccessory(image: NSImage?) -> Slider {
			self._minAccessoryImage = image
			if let tb = self.sliderTouchBarItem {
				tb.minimumValueAccessory = image != nil ? NSSliderAccessory(image: image!) : nil
			}
			return self
		}

		// MARK: - Accessory label (MAX)

		private var _maxAccessoryImage: NSImage?

		/// Set the image to be displayed for the maximum end of the slider
		@discardableResult public func maximumValueAccessory(image: NSImage?) -> Slider {
			self._maxAccessoryImage = image
			if let tb = self.sliderTouchBarItem {
				tb.maximumValueAccessory = image != nil ? NSSliderAccessory(image: image!) : nil
			}
			return self
		}

		// MARK: - Slider Value

		private let _sliderValue = BindableAttributeBinding<CGFloat>()

		/// Set the initial value for the slider
		public func value(_ value: CGFloat) -> Slider {
			self._sliderValue.value = value
			return self
		}

		public func bindValue<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, CGFloat>) -> Slider {
			self._sliderValue.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Initialization and Configuration


		/// Initializer
		/// - Parameters:
		///   - leafIdentifier: the unique identifier for the toolbar item at this level
		///   - customizationLabel: The user-visible string identifying this item during bar customization.
		///   - min: The minimum value for the slider
		///   - max: The maximum value for the slider
		public init(_ leafIdentifier: String,
						customizationLabel: String? = nil,
						min: CGFloat, max: CGFloat)
		{
			assert(min < max)
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)

			self.itemBuilder = { [weak self] in
				self?.makeTouchbarItem(minValue: min, maxValue: max)
			}
		}

		deinit {
			Logging.memory(#"DSFTouchBar.Slider[%@] deinit"#, args: self.identifierString)
		}

		override func destroy() {
			if let slider = self.embeddedControl {
				slider.unbind(NSBindingName.value)
				self.destroyCommon(uiElement: slider)
			}
			super.destroy()
		}

		@objc private func act(_ slider: Any?) {
			if let action = self._action,
				let s = slider as? NSSliderTouchBarItem
			{
				let ee = s.slider.doubleValue
				action(CGFloat(ee))
			}
		}
	}
}

// MARK: Make touchbar item

extension DSFTouchBar.Slider {
	private func makeTouchbarItem(minValue: CGFloat, maxValue: CGFloat) -> NSTouchBarItem? {
		let tb = NSSliderTouchBarItem(identifier: self.identifier)
		tb.customizationLabel = self._customizationLabel

		tb.label = self._label
		tb.action = #selector(self.act(_:))
		tb.target = self
		tb.slider.minValue = Double(minValue)
		tb.slider.maxValue = Double(maxValue)
		if let minImage = self._minAccessoryImage {
			tb.minimumValueAccessory = NSSliderAccessory(image: minImage)
		}
		if let maxImage = self._maxAccessoryImage {
			tb.maximumValueAccessory = NSSliderAccessory(image: maxImage)
		}

		// Init the common elements, and call the create callback if needed
		self.makeCommon(uiElement: tb.slider)

		// Bind the slider value
		self._sliderValue.bind(bindingName: NSBindingName.value, of: tb.slider)

		self.sliderTouchBarItem = tb

		return tb
	}
}
