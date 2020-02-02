//
//  DSFTouchBar.swift
//  Touchbar Tester
//
//  Created by Darren Ford on 28/1/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

import Cocoa

public class DSFTouchBar: NSObject {
	private var mainBar: NSTouchBar? = nil
	private let customizationIdentifier: NSTouchBar.CustomizationIdentifier?

	private var items: [DSFTouchBar.Item] = []
	private var allowedItemIdentifiers: [NSTouchBarItem.Identifier] {
		return items.map { $0.identifier }
	}

	private var defaultIdentifiers: [NSTouchBarItem.Identifier] {

		return items.map { $0.identifier }

//		return items.compactMap {
//			$0 as? UIElementItemBase
//		}
//		.filter { $0._isDefault }
//		.map { $0.identifier }
	}

	public init(customizationIdentifier: NSTouchBar.CustomizationIdentifier? = nil,
				_ children: DSFTouchBar.Item...) {
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

	func add(item: DSFTouchBar.Item) {
		if let i = item as? DSFTouchBar.Group {
			for item in i._children {
				self.items.append(item)
			}
		} else {
			self.items.append(item)
		}
	}

	func item(for identifier: NSTouchBarItem.Identifier) -> DSFTouchBar.Item? {
		return self.items.filter { $0.identifier == identifier }.first
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
