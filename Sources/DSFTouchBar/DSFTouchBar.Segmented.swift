//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import AppKit

private extension NSBindingName {
	static let SegmentedControlSelectionIndexes = NSBindingName("selectedIndexes")
}

extension DSFTouchBar {
	public class Segmented: UIElementItem<NSSegmentedControl> {

		private var _action: (([Int]) -> Void)?
		private var _segments: [(label: String?, image: NSImage?)] = []
		private var _selectedColor: NSColor?

		/// Add a new segment button to the segmented control
		/// - Parameters:
		///   - label: (optional) the text to use for the segmented cell
		///   - image: (optional) the image to use for the segmented cell
		public func add(label: String? = nil, image: NSImage? = nil) -> Segmented {

			// Must specify label, image or both
			assert(label != nil || image != nil)
			_segments.append((label, image))
			return self
		}

		/// Assign an action block to the touchbar item to be called when the control changes state
		public func action(_ action: @escaping (([Int]) -> Void)) -> Segmented {
			_action = action
			return self
		}

		/// Set the color to use for highlighting 'active' cells within the control
		/// - Parameter color: The color to use
		public func selectedColor(_ color: NSColor) -> Segmented {
			_selectedColor = color
			return self
		}

		// MARK: - Selected Index

		private let _selectedIndex = BindableBinding<Int>()
		func selectedIndex(_ value: Int) -> Self {
			self._selectedIndex.value = value
			return self
		}
		public func bindSelectionIndex(to observable: AnyObject, withKeyPath keyPath: String) -> Segmented {
			self._selectedIndex.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Selected Indexes

		private let _selectedIndexes = BindableBinding<NSSet>()
		func selectedIndexes(_ value: Set<Int>) -> Self {
			self._selectedIndexes.value = NSSet(set: value)
			return self
		}
		public func bindSelectionIndexes(to observable: AnyObject, withKeyPath keyPath: String) -> Segmented {
			self._selectedIndexes.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Initializers

		public init(_ leafIdentifier: String, trackingMode: NSSegmentedControl.SwitchTracking = .selectOne ) {
			super.init(leafIdentifier: leafIdentifier)

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				let tb = NSCustomTouchBarItem(identifier: self.identifier)

				tb.customizationLabel = self._customizationLabel

				let segmented = NSSegmentedControl()
				let labels = self._segments.map({ $0.label ?? "" })
				let images = self._segments.map({ $0.image })
				segmented.segmentCount = labels.count
				labels.enumerated().forEach { segmented.setLabel($0.1, forSegment: $0.0) }
				images.enumerated().forEach { segmented.setImage($0.1, forSegment: $0.0) }

				segmented.trackingMode = trackingMode
				segmented.target = self
				segmented.action = #selector(self.act(_:))

				segmented.translatesAutoresizingMaskIntoConstraints = false

				if let color = self._selectedColor {
					segmented.selectedSegmentBezelColor = color
				}

				// Common elements

				self.makeCommon(uiElement: segmented)

				// See if we have to bind to the selected index

				self._selectedIndex.bind(bindingName: NSBindingName.selectedIndex, of: segmented)

				// Multiple selection indexes

				self._selectedIndexes.bind(bindingName: NSBindingName.SegmentedControlSelectionIndexes, of: segmented, checkAvailability: false)

				// For multiple selection, we have to bind the reverse as well, or else we don't get
				// a two-way binding to the control

				self._selectedIndexes.reverseBind()

				tb.view = segmented
				return tb
			}
		}

		override func destroy() {
			_action = nil

			self._selectedIndex.unbind()
			self._selectedIndexes.unbind()

			if let control = self.embeddedControl() {
				self.destroyCommon(uiElement: control)
			}
			super.destroy()
		}

		deinit {
			Swift.print("DSFTouchBar.Segmented(\(self.identifierString)) deinit")
		}

		@objc private func act(_ sender: NSSegmentedControl) {
			var selected: [Int] = []
			let indexes = NSMutableIndexSet()
			for i in 0 ..< sender.segmentCount {
				if sender.isSelected(forSegment: i) {
					selected.append(i)
					indexes.add(i)
				}
			}
			sender.selectedIndexes = indexes
			self._action?(selected)
		}
	}
}

private extension NSSegmentedControl {
	@objc dynamic var selectedIndexes: NSIndexSet {
		get {
			let result = NSMutableIndexSet()
			for i in 0 ..< self.segmentCount {
				if self.isSelected(forSegment: i) {
					result.add(i)
				}
			}
			return result
		}
		set {
			for item in 0 ..< self.segmentCount {
				self.setSelected(newValue.contains(item), forSegment: item)
			}
		}
	}
}
