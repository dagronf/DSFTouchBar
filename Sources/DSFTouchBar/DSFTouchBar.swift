//
//  DSFTouchBar.swift
//  Touchbar Tester
//
//  Created by Darren Ford on 28/1/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

import Cocoa

public class DSFTouchBar: NSObject {
	private weak var mainBar: NSTouchBar? = nil
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

	public func makeTouchBar() -> NSTouchBar? {
		let mainBar = NSTouchBar()
		mainBar.delegate = self
		mainBar.defaultItemIdentifiers = self.defaultIdentifiers
		mainBar.customizationIdentifier = self.customizationIdentifier
		mainBar.customizationAllowedItemIdentifiers = self.allowedItemIdentifiers
		self.mainBar = mainBar
		return mainBar
	}

	deinit {
		self.mainBar = nil
		Swift.print("DSFTouchBar deinit")
	}

	public func add(item: DSFTouchBar.Item) {
		item.baseIdentifier = self.baseIdentifier
		self.items.append(item)

//		if let sc = item as? DSFTouchBar.ScrollGroup {
//			sc._children.forEach { self.items.append($0) }
//		}

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
