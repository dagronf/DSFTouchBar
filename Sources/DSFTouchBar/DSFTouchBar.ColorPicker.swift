//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

private extension NSBindingName {
	static let ColorPickerSelectedColorBindingName = NSBindingName("selectedColor")
}

extension DSFTouchBar {
	public class ColorPicker: UIElementItemBase {
		
		private var item: NSColorPickerTouchBarItem?
		
		private var _action: ((NSColor) -> Void)?

		/// Set the action block to be called when the user chooses a color
		/// - Parameter action: The block to be called
		public func action(_ action: @escaping ((NSColor) -> Void)) -> ColorPicker {
			_action = action
			return self
		}
		
		private var _showAlpha: Bool = false
		public func showAlpha(_ show: Bool) -> ColorPicker {
			_showAlpha = show
			return self
		}

		private let _selectedColor = BindableBinding<NSColor>()
		public func bindSelectedColor(to observable: AnyObject, withKeyPath keyPath: String) -> ColorPicker {
			_selectedColor.setup(observable: observable, keyPath: keyPath)
			return self
		}
		
		@objc dynamic var selectedColor: NSColor {
			get {
				return self.item?.color ?? NSColor.white
			}
			set {
				self.item?.color = newValue
			}
		}
		
		public init(_ leafIdentifier: String, customizationLabel: String? = nil) {
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)
			
			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}
				
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

		override func destroy() {

			self._selectedColor.unbind()

			self._action = nil
			self.item = nil

			super.destroy()
		}

		deinit {
			Swift.print("DSFTouchBar.ColorPicker(\(self.identifierString)) deinit")
		}

		@objc public func act(_ colorPicker: Any?) {
			
			guard let colorpicker = colorPicker as? NSColorPickerTouchBarItem else {
				return
			}
			
			// Pass the changed color value back to our observer if someone is watching
			if let observer = self._selectedColor.bindValueObserver,
			   let keyPath = self._selectedColor.bindValueKeyPath {
				observer.setValue(colorpicker.color, forKey: keyPath)
			}
			
			if let action = self._action {
				action(colorpicker.color)
			}
		}
	}
	
}
