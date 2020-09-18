//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

extension DSFTouchBar {
	public class Popover: UIElementItemBase {

		private var popoverContent: DSFTouchBar? = nil

		// Cleanup handle
		private var AssociatedObjectHandle: UInt8 = 0


		private(set) var _children: [DSFTouchBar.Item] = []
		public init(_ leafIdentifier: String,
			 collapsedLabel: String? = nil,
			 collapsedImage: NSImage? = nil,
			 _ children: [DSFTouchBar.Item]) {
			_children = children
			super.init(leafIdentifier: leafIdentifier)

			self.maker = { [weak self] in
				guard let `self` = self else { return nil }

				self.popoverContent = nil

				let rc = self.baseIdentifier!.rawValue + "." + self.leafIdentifier
				let pc = DSFTouchBar(baseIdentifier: NSTouchBarItem.Identifier(rc))

				for item in self._children {
					pc.add(item: item)
				}

				let tb = NSPopoverTouchBarItem(identifier: self.identifier)
				tb.customizationLabel = self._customizationLabel

				if let label = collapsedLabel {
					tb.collapsedRepresentationLabel = label
				}
				tb.collapsedRepresentationImage = collapsedImage

				if let mtb = pc.makeTouchBar() {
					tb.pressAndHoldTouchBar = mtb
					tb.popoverTouchBar = mtb
				}

				// Tie the lifecycle of the DSFToolbar object to the lifecycle of the nstoolbar
				// so that we don't have to manually destroy it
				objc_setAssociatedObject(tb, &self.AssociatedObjectHandle, pc, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

				self.popoverContent = pc

				self._children = []

				return tb
			}
		}

		override func destroy() {
			//self._children.forEach { $0.destroy() }

			self.popoverContent?.destroy()
			self.popoverContent = nil
			super.destroy()
		}

		deinit {
			Swift.print("DSFTouchBar.Popover(\(self.identifierString)) deinit")
		}
	}
}
