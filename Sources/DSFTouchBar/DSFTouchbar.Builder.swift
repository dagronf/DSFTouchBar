//
//  File.swift
//  
//
//  Created by Darren Ford on 18/9/20.
//

import Cocoa

extension DSFTouchBar {

	public class Builder: NSObject {

		// (Optional) the customization identifier for the toolbar
		private let customizationIdentifier: NSTouchBar.CustomizationIdentifier?

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

		// Cleanup handle
		private var AssociatedObjectHandle: UInt8 = 0

		public func makeTouchBar() -> NSTouchBar? {
			let mainBar = NSTouchBar()
			mainBar.delegate = self
			mainBar.defaultItemIdentifiers = self.defaultIdentifiers
			mainBar.customizationIdentifier = self.customizationIdentifier
			mainBar.customizationAllowedItemIdentifiers = self.allowedItemIdentifiers

			// Tie the lifecycle of the DSFToolbar object to the lifecycle of the nstoolbar
			// so that we don't have to manually destroy it
			objc_setAssociatedObject(mainBar, &AssociatedObjectHandle, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

			return mainBar
		}

		deinit {
			self.destroy()
			Swift.print("DSFTouchBar(\(self.baseIdentifier.rawValue)) deinit")
		}

		/// Add a new item to the toolbar
		public func add(item: DSFTouchBar.Item) {
			item.baseIdentifier = self.baseIdentifier

			// Check to make sure that we don't already have a toolbar item with this identifier
			if let match = self.items.filter({ $0.identifierString == item.identifierString }).first {
				fatalError("Attempted to add touchbar with matching identifier (\(match.identifierString))")
			}

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

extension DSFTouchBar.Builder: NSTouchBarDelegate {
	public func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
		guard let item = self.item(for: identifier),
			  let makerBlock = item.maker else {
			return nil
		}
		return makerBlock()
	}
}
