//
//  DSFTouchBar.SharingServicePicker.swift
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
	/// A sharing service touchbar item
	class SharingServicePicker: UIElementItemBase {
		var sharingServiceItem: NSSharingServicePickerTouchBarItem?

		// MARK: - Enabled support

		private let _enabled = BindableTypedAttribute<Bool>()

		/// Bind the enabled state for the sharing service touchbar item to a key path
		public func bindIsEnabled<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, Bool>) -> SharingServicePicker {
			self._enabled.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Title bindings and settings

		private let _title = BindableTypedAttribute<String>()

		/// Provide the title for the sharing service control
		public func title(_ title: String) -> SharingServicePicker {
			self._title.value = title
			return self
		}

		// MARK: - Image bindings and settings

		private var _image: NSImage?

		/// Provide the image for the sharing service control
		public func image(_ image: NSImage?) -> SharingServicePicker {
			self._image = image
			return self
		}

		// MARK: - Provide items callback

		private var provideItemsBlock: (() -> [Any])?

		/// Provide a block that is called to retrieve the items that are to be shared
		public func provideItems(_ block: @escaping (() -> [Any])) -> Self {
			self.provideItemsBlock = block
			return self
		}

		// MARK: - Initialization/Destruction

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
				self?.makeTouchbarItem()
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
			Logging.memory(#"DSFTouchBar.SharingServicePicker[%@] deinit"#, args: self.identifierString)
		}
	}
}

extension DSFTouchBar.SharingServicePicker {
	private func makeTouchbarItem() -> NSTouchBarItem? {
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

extension DSFTouchBar.SharingServicePicker: NSSharingServicePickerTouchBarItemDelegate {
	public func items(for _: NSSharingServicePickerTouchBarItem) -> [Any] {
		return self.provideItemsBlock?() ?? []
	}
}
