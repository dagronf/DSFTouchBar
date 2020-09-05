//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {
	public class Slider: UIElementItem<NSSlider> {

		private var _action: ((CGFloat) -> Void)?
		public func action(_ action: @escaping ((CGFloat) -> Void)) -> Slider {
			_action = action
			return self
		}

		private var _label: String?
		public func label(_ label: String) -> Slider {
			_label = label
			return self
		}

		private var _minAccessoryImage: NSImage?
		public func minimumValueAccessory(image: NSImage?) -> Slider {
			_minAccessoryImage = image
			return self
		}

		private var _maxAccessoryImage: NSImage?
		public func maximumValueAccessory(image: NSImage?) -> Slider {
			_maxAccessoryImage = image
			return self
		}

		private var bindObserver: Any? = nil
		private var bindKeyPath: String? = nil
		public func bindValue(to observable: Any, withKeyPath keyPath: String) -> Slider {
			self.bindObserver = observable
			self.bindKeyPath = keyPath
			return self
		}

		public init(_ leafIdentifier: String, min: CGFloat, max: CGFloat) {
			assert(min < max)
			super.init(leafIdentifier: leafIdentifier)

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

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

				if let observer = self.bindObserver,
					let keyPath = self.bindKeyPath {
					tb.slider.bind(NSBindingName.value,
								   to: observer,
								   withKeyPath: keyPath,
								   options: nil)
				}

				// Init the common elements, and call the create callback if needed
				self.makeCommon(uiElement: tb.slider)

				return tb
			}
		}

		deinit {
			Swift.print("DSFTouchBar.Slider deinit")
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
