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

extension DSFTouchBar {
	public class Slider: UIElementItem<NSSlider> {

		private weak var sliderTouchBarItem: NSSliderTouchBarItem?

		private var _action: ((CGFloat) -> Void)?
		public func action(_ action: @escaping ((CGFloat) -> Void)) -> Slider {
			_action = action
			return self
		}

		// MARK: - Slider label

		private var _label: String?
		public func label(_ label: String) -> Slider {
			_label = label
			return self
		}

		// MARK: - Accessory label (MIN)

		private var _minAccessoryImage: NSImage?
		@discardableResult public func minimumValueAccessory(image: NSImage?) -> Slider {
			_minAccessoryImage = image
			if let tb = self.sliderTouchBarItem {
				tb.minimumValueAccessory = image != nil ? NSSliderAccessory(image: image!) : nil
			}
			return self
		}

		// MARK: - Accessory label (MAX)

		private var _maxAccessoryImage: NSImage?
		@discardableResult public func maximumValueAccessory(image: NSImage?) -> Slider {
			_maxAccessoryImage = image
			if let tb = self.sliderTouchBarItem {
				tb.maximumValueAccessory = image != nil ? NSSliderAccessory(image: image!) : nil
			}
			return self
		}

		// MARK: - Slider Value

		private let _sliderValue = BindableBinding<CGFloat>()

		public func value(_ value: CGFloat) -> Slider {
			_sliderValue.value = value
			return self
		}

		public func bindValue(to observable: AnyObject, withKeyPath keyPath: String) -> Slider {
			_sliderValue.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Initialization and Configuration

		public init(_ leafIdentifier: String,
					customizationLabel: String? = nil,
					min: CGFloat, max: CGFloat) {
			assert(min < max)
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)

			self.itemBuilder = { [weak self] in
				guard let `self` = self else { return nil }

				let tb = NSSliderTouchBarItem(identifier: self.identifier)
				tb.customizationLabel = self._customizationLabel

				tb.label = self._label
				tb.action = #selector(self.act(_:))
				tb.target = self
				tb.slider.minValue = Double(min)
				tb.slider.maxValue = Double(max)
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

		deinit {
			Swift.print("DSFTouchBar.Slider(\(self.identifierString)) deinit")
		}

		override func destroy() {
			if let slider = self.embeddedControl() {
				slider.unbind(NSBindingName.value)
				self.destroyCommon(uiElement: slider)
			}
			super.destroy()
		}

		@objc public func act(_ slider: Any?) {
			if let action = self._action,
				let s = slider as? NSSliderTouchBarItem {
				let ee = s.slider.doubleValue
				action(CGFloat(ee))
			}
		}
	}
}
