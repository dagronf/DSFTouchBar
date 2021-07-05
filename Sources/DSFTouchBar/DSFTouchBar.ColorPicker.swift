//
//  DSFTouchBar.ColorPicker.swift
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

private extension NSBindingName {
	static let ColorPickerSelectedColorBindingName = NSBindingName("selectedColor")
}

public extension DSFTouchBar {
	/// A color-picker touchbar item
	class ColorPicker: UIElementItemBase {
		// The toolbar item
		private var item: NSColorPickerTouchBarItem?
		
		// The action to be performed when the color changes
		private var _action: ((NSColor) -> Void)?
		
		/// - Parameter action: The block to be called
		///
		
		/// Set the action block to be called when the user chooses a color
		/// - Parameter action: The block to be called
		/// - Returns: The ColorPicker object
		public func action(_ action: @escaping ((NSColor) -> Void)) -> ColorPicker {
			self._action = action
			return self
		}
		
		// MARK: - Allow Alpha
		
		private var _showAlpha: Bool = false
		
		/// Allow non-opaque colors to be selected
		/// - Parameter show: if true, allow colors with alpha values < 1, otherwise
		/// - Returns: The ColorPicker object
		public func showAlpha(_ show: Bool) -> ColorPicker {
			self._showAlpha = show
			return self
		}
		
		// MARK: - Selected color
		
		private let _selectedColor = BindableAttributeBinding<NSColor>()
		
		public func bindSelectedColor<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, NSColor>) -> ColorPicker {
			self._selectedColor.setup(observable: observable, keyPath: keyPath)
			return self
		}

		/// The currently selected color
		@objc dynamic var selectedColor: NSColor {
			get {
				return self.item?.color ?? NSColor.white
			}
			set {
				self.item?.color = newValue
			}
		}

		// MARK: - Enabled

		private let _isEnabled = BindableAttributeBinding<Bool>()

		public func bindIsEnabled<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, Bool>) -> ColorPicker {
			self._isEnabled.setup(observable: observable, keyPath: keyPath)
			return self
		}

		/// The currently selected color
		@objc dynamic var isEnabled: Bool {
			get {
				return self.item?.isEnabled ?? false
			}
			set {
				self.item?.isEnabled = newValue
			}
		}
		
		// MARK: - Initializers
		
		/// Initializer
		/// - Parameters:
		///   - leafIdentifier: the unique identifier for the toolbar item at this level
		///   - customizationLabel: The user-visible string identifying this item during bar customization.
		public init(_ leafIdentifier: String, customizationLabel: String? = nil) {
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)
			
			self.itemBuilder = { [weak self] in
				self?.makeTouchbarItem()
			}
		}
		
		override func destroy() {
			self._selectedColor.unbind()
			
			self._action = nil
			self.item = nil
			
			super.destroy()
		}
		
		deinit {
			Logging.memory(#"DSFTouchBar.ColorPicker[%@] deinit"#, args: self.identifierString)
		}
		
		@objc public func act(_ colorPicker: Any?) {
			guard let colorpicker = colorPicker as? NSColorPickerTouchBarItem else {
				return
			}
			
			// Pass the changed color value back to our observer if someone is watching
			if let observer = self._selectedColor.bindValueObserver,
				let keyPath = self._selectedColor.bindValueKeyPath
			{
				observer.setValue(colorpicker.color, forKey: keyPath)
			}
			
			self._action?(colorpicker.color)
		}
	}
}

// MARK: Make touchbar item

extension DSFTouchBar.ColorPicker {
	private func makeTouchbarItem() -> NSTouchBarItem? {
		let touchbar = NSColorPickerTouchBarItem(identifier: self.identifier)
		touchbar.customizationLabel = self._customizationLabel
		
		touchbar.target = self
		touchbar.action = #selector(self.act(_:))
		
		touchbar.showsAlpha = self._showAlpha
		
		self.item = touchbar
		
		// Color observer
		
		self._selectedColor.bind(
			bindingName: NSBindingName.ColorPickerSelectedColorBindingName,
			of: self,
			checkAvailability: false
		)
		
		return touchbar
	}
}
