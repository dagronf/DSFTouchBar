//
//  DSFTouchBar.swift
//  Touchbar Tester
//
//  Created by Darren Ford on 28/1/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

import Cocoa

public class DSFTouchBar: NSObject {
	private let customizationIdentifier: NSTouchBar.CustomizationIdentifier?

	private var items: [DSFTouchBar.Item] = []
	private var allowedItemIdentifiers: [NSTouchBarItem.Identifier] {
		return items.map { $0.identifier }
	}

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
		Swift.print("DSFTouchBar deinit")
	}

	public func add(item: DSFTouchBar.Item) {
		item.baseIdentifier = self.baseIdentifier
		self.items.append(item)
	}

	public func add(_ children: DSFTouchBar.Item...) {
		children.forEach { self.add(item: $0) }
	}

	public func item(for identifier: NSTouchBarItem.Identifier) -> DSFTouchBar.Item? {
		return self.items.filter { $0.identifier == identifier }.first
	}

	public func destroy() {
		self.items.forEach { $0.destroy() }
		self.items = []
	}
}

extension DSFTouchBar: NSTouchBarDelegate {
	public func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
		guard let item = self.item(for: identifier),
			let makerBlock = item.maker else {
			return nil
		}
		return makerBlock()
	}
}
