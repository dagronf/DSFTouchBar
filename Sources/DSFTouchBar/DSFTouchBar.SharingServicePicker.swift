//
//  SharingServicePicker.swift
//
//
//  Created by Darren Ford on 3/9/20.
//

import AppKit

extension DSFTouchBar {
	public class SharingServicePicker: UIElementItemBase {
		var sharingServiceItem: NSSharingServicePickerTouchBarItem?

		private var bindObserver: NSObject?
		private var bindKeyPath: String?
		public func bindEnabled(to observable: NSObject, withKeyPath keyPath: String) -> SharingServicePicker {
			self.bindObserver = observable
			self.bindKeyPath = keyPath
			return self
		}

		var provideItemsBlock: (() -> [Any])?
		public func provideItems(_ block: @escaping (() -> [Any])) -> Self {
			self.provideItemsBlock = block
			return self
		}

		public init(identifier: NSTouchBarItem.Identifier,
					title _: String)
		{
			super.init(ident: identifier)

			self.maker = { [weak self] in
				guard let `self` = self else { return nil }

				let item = NSSharingServicePickerTouchBarItem(identifier: identifier)
				item.delegate = self

				self.sharingServiceItem = item

				// If the user has specified an 'enabled' binding, attach it.
				if let observer = self.bindObserver, let keyPath = self.bindKeyPath {
					observer.addObserver(self, forKeyPath: keyPath, options: [.new], context: nil)

					// Set the initial value from the bound variable
					if let v = observer.value(forKeyPath: keyPath), let enabled = v as? Bool {
						self.sharingServiceItem?.isEnabled = enabled
					}
				}

				return item
			}
		}

		override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
			if let bindKeyPath = self.bindKeyPath,
			   bindKeyPath == keyPath,
			   let newVal = change?[.newKey] as? Bool
			{
				self.sharingServiceItem?.isEnabled = newVal
			}
			else {
				super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
			}
		}

		override func destroy() {
			if let observer = self.bindObserver, let keyPath = self.bindKeyPath {
				observer.removeObserver(self, forKeyPath: keyPath)
			}
			self.provideItemsBlock = nil
			self.bindObserver = nil
			self.sharingServiceItem = nil
			super.destroy()
		}

		deinit {
			Swift.print("DSFTouchBar.SharingServicePicker deinit")
		}
	}
}

extension DSFTouchBar.SharingServicePicker: NSSharingServicePickerTouchBarItemDelegate {
	public func items(for pickerTouchBarItem: NSSharingServicePickerTouchBarItem) -> [Any] {
		return self.provideItemsBlock?() ?? []
	}
}
