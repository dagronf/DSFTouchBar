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
		
		private var bindSelectedColorObserver: AnyObject? = nil
		private var bindSelectedColorKeyPath: String? = nil
		public func bindSelectedColor(to observable: AnyObject, withKeyPath keyPath: String) -> ColorPicker {
			self.bindSelectedColorObserver = observable
			self.bindSelectedColorKeyPath = keyPath
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
		
		public init(_ identifier: NSTouchBarItem.Identifier) {
			super.init(ident: identifier)
			
			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}
				
				let touchbar = NSColorPickerTouchBarItem(identifier: self.identifier)
				
				touchbar.target = self
				touchbar.action = #selector(self.act(_:))
				
				touchbar.showsAlpha = self._showAlpha
				
				self.item = touchbar
				
				if let observer = self.bindSelectedColorObserver, let keyPath = self.bindSelectedColorKeyPath {
					self.bind(
						NSBindingName.ColorPickerSelectedColorBindingName,
						to: observer,
						withKeyPath: keyPath,
						options: [NSBindingOption.continuouslyUpdatesValue : NSNumber(value: true)])
				}
				
				return touchbar
			}
		}
		
		deinit {
			self.unbind(NSBindingName.ColorPickerSelectedColorBindingName)
		}
		
		@objc public func act(_ colorPicker: Any?) {
			
			guard let colorpicker = colorPicker as? NSColorPickerTouchBarItem else {
				return
			}
			
			// Pass the changed color value back to our observer if someone is watching
			if let observer = self.bindSelectedColorObserver, let keyPath = self.bindSelectedColorKeyPath {
				observer.setValue(colorpicker.color, forKey: keyPath)
			}
			
			if let action = self._action {
				action(colorpicker.color)
			}
		}
	}
	
}
