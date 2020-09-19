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

		private let _enabled = BindableAttribute<Bool>()
		public func bindEnabled(to observable: NSObject, withKeyPath keyPath: String) -> SharingServicePicker {
			self._enabled.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Title bindings and settings

		private let _title = BindableAttribute<String>()
		public func title(_ title: String) -> SharingServicePicker {
			_title.value = title
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
		///   - customizationLabel: The label to be displayed in the customization panel
		///   - title: An optional title to be displayed on the share button
		///   - image: An optional image to be displayed on the share button
		public init(_ leafIdentifier: String,
					customizationLabel: String? = nil,
					title: String? = nil,
					image: NSImage? = nil)
		{
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)

			self._title.value = title
			self._image = image

			self.itemBuilder = { [weak self] in
				guard let `self` = self else { return nil }

				let item = NSSharingServicePickerTouchBarItem(identifier: self.identifier)
				item.delegate = self
				item.isEnabled = true

				self.sharingServiceItem = item

				if let image = self._image {
					item.buttonImage = image
				}

				if let title = self._title.value {
					item.buttonTitle = title
				}

				// If the user has specified an 'enabled' binding, attach it.
				self._enabled.bind { [weak self] newEnabledState in
					self?.sharingServiceItem?.isEnabled = newEnabledState
				}

				// If the user has specified a 'title' binding, attach it.
				self._title.bind { [weak self] newTitle in
					self?.sharingServiceItem?.buttonTitle = newTitle
				}

				return item
			}
		}

		override func destroy() {
			self._enabled.unbind()
			self._title.unbind()

			self.provideItemsBlock = nil
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
