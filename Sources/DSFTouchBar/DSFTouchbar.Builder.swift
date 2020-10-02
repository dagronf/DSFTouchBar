//
//  DSFTouchBar.Builder.swift
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

import Cocoa

// Cleanup handle
private var DSFTouchBarBuilderAssociatedObjectHandle: UInt8 = 0

extension DSFTouchBar {

	public class Builder: NSObject {

		// (Optional) the customization identifier for the toolbar
		private let customizationIdentifier: NSTouchBar.CustomizationIdentifier?

		// The items to be added to the touchbar
		private var items: [DSFTouchBar.Item] = []

		// For DSFTouchBar, all items are allowed to be displayed
		private var allowedItemIdentifiers: [NSTouchBarItem.Identifier] {
			return items.map { $0.identifier }
		}

		// For DSFTouchBar, the default identifiers are as they are built in the Builder object
		private var defaultIdentifiers: [NSTouchBarItem.Identifier] {
			return items.map { $0.identifier }
		}

		private let baseIdentifier: NSTouchBarItem.Identifier

		public init(baseIdentifier: NSTouchBarItem.Identifier,
					customizationIdentifier: NSTouchBar.CustomizationIdentifier? = nil,
					_ children: DSFTouchBar.Item...) {
			self.baseIdentifier = baseIdentifier
			self.customizationIdentifier = customizationIdentifier
			super.init()
			for item in children {
				self.add(item: item)
			}
		}

		public init(baseIdentifier: NSTouchBarItem.Identifier,
					customizationIdentifier: NSTouchBar.CustomizationIdentifier? = nil,
					children: [DSFTouchBar.Item]) {
			self.baseIdentifier = baseIdentifier
			self.customizationIdentifier = customizationIdentifier
			super.init()
			children.forEach { self.add($0) }
		}

		public func makeTouchBar() -> NSTouchBar? {
			let mainBar = NSTouchBar()
			mainBar.delegate = self
			mainBar.defaultItemIdentifiers = self.defaultIdentifiers
			mainBar.customizationIdentifier = self.customizationIdentifier
			mainBar.customizationAllowedItemIdentifiers = self.allowedItemIdentifiers

			// Tie the lifecycle of the DSFToolbar object to the lifecycle of the nstoolbar
			// so that we don't have to manually destroy it
			objc_setAssociatedObject(mainBar, &DSFTouchBarBuilderAssociatedObjectHandle, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

			return mainBar
		}

		deinit {
			self.destroy()
			Swift.print("DSFTouchBar(\(self.baseIdentifier.rawValue)) deinit")
		}

		/// Add a new item to the toolbar
		public func add(item: DSFTouchBar.Item) {
			item.baseIdentifier = self.baseIdentifier
			self.items.append(item)
		}

		/// Add new items to the toolbar
		public func add(_ children: DSFTouchBar.Item...) {
			children.forEach { self.add(item: $0) }
		}

		/// Locate an item with the matching touchBarItem identifier
		/// - Parameter identifier: The identifier for the item to locate
		/// - Returns: The touchbar item, or nil if not found
		public func item(for identifier: NSTouchBarItem.Identifier) -> DSFTouchBar.Item? {
			return self.items.filter { $0.identifier == identifier }.first
		}

		public func destroy() {
			self.items.forEach { $0.destroy() }
			self.items = []
		}
	}
}

extension DSFTouchBar.Builder {
	static func Retrieve(from touchBar: NSTouchBar) -> DSFTouchBar.Builder? {
		return objc_getAssociatedObject(touchBar, &DSFTouchBarBuilderAssociatedObjectHandle) as? DSFTouchBar.Builder
	}
}


extension DSFTouchBar.Builder: NSTouchBarDelegate {
	public func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
		guard let item = self.item(for: identifier),
			  let makerBlock = item.itemBuilder else {
			return nil
		}
		return makerBlock()
	}
}
