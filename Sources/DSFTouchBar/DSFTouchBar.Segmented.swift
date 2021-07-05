//
//  DSFTouchBar.Segmented.swift
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

private extension NSBindingName {
	static let SegmentedControlSelectionIndexes = NSBindingName("selectedIndexes")
}

public extension DSFTouchBar {
	/// A segmented control for the touchbar
	class Segmented: UIElementItem<NSSegmentedControl> {
		/// A segment definition for a segmented control
		public struct Segment {
			public let label: String?
			public let image: NSImage?
			public init(_ label: String? = nil, _ image: NSImage? = nil) {
				self.label = label
				self.image = image
			}
		}

		// MARK: - Add segments

		// The segment definitions
		private var _segments: [Segment] = []

		/// The segments defined for the segmented control
		public var segments: [Segment] {
			return _segments
		}

		/// Add a new segment button to the segmented control
		/// - Parameters:
		///   - label: (optional) the text to use for the segmented cell
		///   - image: (optional) the image to use for the segmented cell
		public func add(label: String? = nil, image: NSImage? = nil) -> Segmented {
			// Must specify label, image or both
			assert(label != nil || image != nil)
			self._segments.append(Segment(label, image))
			return self
		}

		/// Add a new segment button to the segmented control
		/// - Parameters:
		///   - label: (optional) the text to use for the segmented cell
		///   - image: (optional) the image to use for the segmented cell
		public func add(_ segment: Segment) -> Segmented {
			// Must specify label, image or both
			self._segments.append(segment)
			return self
		}

		// MARK: - Action

		/// The bound action
		private var _action: ((Set<Int>) -> Void)?

		/// Assign an action block to the touchbar item to be called when the control changes state
		/// - Parameter action: The action to call when the selection(s) change in the control.
		/// - Returns: self
		public func action(_ action: @escaping ((Set<Int>) -> Void)) -> Segmented {
			self._action = action
			return self
		}

		// MARK: - Selected Color

		private var _selectedColor: NSColor?

		/// Set the color to use for highlighting 'active' cells within the control
		/// - Parameter color: The color to use
		/// - Returns: self
		public func selectedColor(_ color: NSColor) -> Segmented {
			self._selectedColor = color
			return self
		}

		// MARK: - Selected Indexes

		private let _selectedIndexes = BindableAttributeBinding<NSIndexSet>()

		/// Set the selection for the segmented control
		/// - Parameter value: The segmentedcontrol segments to select
		/// - Returns: self
		public func selectedIndexes(_ value: Set<Int>) -> Self {
			self._selectedIndexes.value = NSIndexSet(value)
			return self
		}

		/// Bind the selection to an NSIndexSet
		/// - Parameters:
		///   - observable: The object containing the NSIndexSet to be observed
		///   - keyPath: The keyPath to the NSIndexSet to be observed
		/// - Returns: self
		public func bindSelection<TYPE>(to observable: NSObject, withKeyPath keyPath: ReferenceWritableKeyPath<TYPE, NSIndexSet>) -> Segmented {
			self._selectedIndexes.setup(observable: observable, keyPath: keyPath)
			return self
		}

		// MARK: - Initializers

		/// Initializer
		/// - Parameters:
		///   - leafIdentifier: the unique identifier for the toolbar item at this level
		///   - customizationLabel: The user-visible string identifying this item during bar customization.
		///   - trackingMode: Specifies the type of tracking behavior the segmented control exhibits
		public init(
			_ leafIdentifier: LeafIdentifier,
			customizationLabel: String? = nil,
			trackingMode: NSSegmentedControl.SwitchTracking = .selectOne
		) {
			super.init(leafIdentifier: leafIdentifier, customizationLabel: customizationLabel)

			self.itemBuilder = { [weak self] in
				self?.makeTouchbarItem(trackingMode: trackingMode)
			}
		}

		/// Initializer
		/// - Parameters:
		///   - leafIdentifier: the unique identifier for the toolbar item at this level
		///   - customizationLabel: The user-visible string identifying this item during bar customization.
		///   - trackingMode: Specifies the type of tracking behavior the segmented control exhibits
		///   - segments: The segments to initialize the control with
		public convenience init(
			_ leafIdentifier: LeafIdentifier,
			customizationLabel: String? = nil,
			trackingMode: NSSegmentedControl.SwitchTracking = .selectOne,
			segments: [Segment]
		) {
			self.init(leafIdentifier, customizationLabel: customizationLabel, trackingMode: trackingMode)
			segments.forEach {
				self._segments.append($0)
			}
		}

		override func destroy() {
			self._action = nil

			self._selectedIndexes.unbind()

			if let control = self.embeddedControl {
				self.destroyCommon(uiElement: control)
			}
			super.destroy()
		}

		deinit {
			Logging.memory(#"DSFTouchBar.Segmented[%@] deinit"#, args: self.identifierString)
		}

		// Gets called when the user interacts with the control
		@objc private func act(_ sender: NSSegmentedControl) {
			let selectedIndexes = sender.selectedIndexSet

			// Have to force update our custom observable unfortunately.
			sender.selectedIndexes = NSIndexSet(indexSet: selectedIndexes)

			// And pass the action onto the owner if it was requested
			self._action?(Set(selectedIndexes))
		}
	}
}

// MARK: Make touchbar item

extension DSFTouchBar.Segmented {
	private func makeTouchbarItem(trackingMode: NSSegmentedControl.SwitchTracking) -> NSTouchBarItem? {
		let tb = NSCustomTouchBarItem(identifier: self.identifier)

		tb.customizationLabel = self._customizationLabel

		let segmented = NSSegmentedControl()
		let labels = self._segments.map { $0.label ?? "" }
		let images = self._segments.map { $0.image }
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

		// Multiple selection indexes

		self._selectedIndexes.bind(bindingName: NSBindingName.SegmentedControlSelectionIndexes, of: segmented, checkAvailability: false)

		// For multiple selection, we have to bind the reverse as well, or else we don't get
		// a two-way binding to the control

		self._selectedIndexes.reverseBind()

		tb.view = segmented
		return tb
	}
}
