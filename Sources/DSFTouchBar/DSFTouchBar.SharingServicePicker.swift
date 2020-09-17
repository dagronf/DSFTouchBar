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

		// MARK: - Enabled support

		private var bindEnabledObserver: NSObject?
		private var bindEnabledKeyPath: String?
		public func bindEnabled(to observable: NSObject, withKeyPath keyPath: String) -> SharingServicePicker {
			self.bindEnabledObserver = observable
			self.bindEnabledKeyPath = keyPath
			return self
		}

		// MARK: - Title bindings and settings

		private var _title: String?
		public func title(_ title: String) -> SharingServicePicker {
			_title = title
			return self
		}

		private var bindTitleObserver: AnyObject?
		private var bindTitleKeyPath: String?
		public func bindTitle(to observable: AnyObject, withKeyPath keyPath: String) -> SharingServicePicker {
			self.bindTitleObserver = observable
			self.bindTitleKeyPath = keyPath
			return self
		}

		// MARK: - Image bindings and settings

		private var _image: NSImage?
		public func image(_ image: NSImage?) -> SharingServicePicker {
			_image = image
			return self
		}

		private var provideItemsBlock: (() -> [Any])?

		/// Provide the block that is called to retrieve the items that are to be shared
		public func provideItems(_ block: @escaping (() -> [Any])) -> Self {
			self.provideItemsBlock = block
			return self
		}

		/// Create a new sharing button in the toolbar.
		/// - Parameters:
		///   - leafIdentifier: The leaf identifier for the share item. Must be unique within the current toolbar
		///   - title: An optional title to be displayed on the share button
		///   - image: An optional image to be displayed on the share button
		public init(_ leafIdentifier: String,
					title: String? = nil,
					image: NSImage? = nil)
		{
			super.init(leafIdentifier: leafIdentifier)

			self._title = title
			self._image = image

			self.maker = { [weak self] in
				guard let `self` = self else { return nil }

				let item = NSSharingServicePickerTouchBarItem(identifier: self.identifier)
				item.delegate = self
				item.isEnabled = true

				self.sharingServiceItem = item

				if let image = self._image {
					item.buttonImage = image
				}

				if let title = self._title {
					item.buttonTitle = title
				}

				// If the user has specified an 'enabled' binding, attach it.
				if let observer = self.bindEnabledObserver, let keyPath = self.bindEnabledKeyPath {
					observer.addObserver(self, forKeyPath: keyPath, options: [.new], context: nil)

					// Set the initial value from the bound variable
					if let v = observer.value(forKeyPath: keyPath), let enabled = v as? Bool {
						self.sharingServiceItem?.isEnabled = enabled
					}
				}

				// If the user has specified a 'title' binding, attach it.
				if let observer = self.bindTitleObserver, let keyPath = self.bindTitleKeyPath {
					observer.addObserver(self, forKeyPath: keyPath, options: [.new], context: nil)

					// Set the initial value from the bound variable
					if let v = observer.value(forKeyPath: keyPath), let title = v as? String {
						self.sharingServiceItem?.buttonTitle = title
					}
				}

				return item
			}
		}

		override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
			if let bindKeyPath = self.bindEnabledKeyPath, bindKeyPath == keyPath,
			   let newVal = change?[.newKey] as? Bool {
				self.sharingServiceItem?.isEnabled = newVal
			}
			else if let bindKeyPath = self.bindTitleKeyPath, bindKeyPath == keyPath,
			   let newVal = change?[.newKey] as? String {
				self.sharingServiceItem?.buttonTitle = newVal
			}
			else {
				super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
			}
		}

		override func destroy() {
			if let observer = self.bindEnabledObserver, let keyPath = self.bindEnabledKeyPath {
				observer.removeObserver(self, forKeyPath: keyPath)
			}
			if let observer = self.bindTitleObserver, let keyPath = self.bindTitleKeyPath {
				observer.removeObserver(self, forKeyPath: keyPath)
			}
			self.provideItemsBlock = nil
			self.bindEnabledObserver = nil
			self.bindTitleObserver = nil
			self.sharingServiceItem = nil
			super.destroy()
		}

		deinit {
			Swift.print("DSFTouchBar.SharingServicePicker(\(self.identifierString)) deinit")
		}
	}
}

extension DSFTouchBar.SharingServicePicker: NSSharingServicePickerTouchBarItemDelegate {
	public func items(for _: NSSharingServicePickerTouchBarItem) -> [Any] {
		return self.provideItemsBlock?() ?? []
	}
}
