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

		/// Assign an action block to the touchbar item to be called when the control changes state
		public func action(_ action: @escaping (([Int]) -> Void)) -> Segmented {
			_action = action
			return self
		}

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


		/// Set the color to use for highlighting 'active' cells within the control
		/// - Parameter color: The color to use
		public func selectedColor(_ color: NSColor) -> Segmented {
			_selectedColor = color
			return self
		}

		private var bindSelectedIndexObserver: Any? = nil
		private var bindSelectedIndexKeyPath: String? = nil
		public func bindSelectedIndex(to observable: Any, withKeyPath keyPath: String) -> Segmented {
			self.bindSelectedIndexObserver = observable
			self.bindSelectedIndexKeyPath = keyPath
			return self
		}

		private var bindObserver2: AnyObject? = nil
		private var bindKeyPath2: String? = nil
		public func bindSelectionIndexes(to observable: AnyObject, withKeyPath keyPath: String) -> Segmented {
			self.bindObserver2 = observable
			self.bindKeyPath2 = keyPath
			return self
		}

		public init(_ identifier: NSTouchBarItem.Identifier, trackingMode: NSSegmentedControl.SwitchTracking = .selectOne ) {
			super.init(ident: identifier)

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				let tb = NSCustomTouchBarItem(identifier: self.identifier)

				let segmented = NSSegmentedControl()
				let labels = self._segments.map({ $0.label ?? "" })
				segmented.segmentCount = labels.count
				labels.enumerated().forEach { segmented.setLabel($0.1, forSegment: $0.0) }
				segmented.trackingMode = trackingMode
				segmented.target = self
				segmented.action = #selector(self.act(_:))

				segmented.translatesAutoresizingMaskIntoConstraints = false

				if let color = self._selectedColor {
					segmented.selectedSegmentBezelColor = color
				}

				// See if we have to bind to the selected index
				if let observer = self.bindSelectedIndexObserver,
					let keyPath = self.bindSelectedIndexKeyPath {
					segmented.bind(
						NSBindingName.selectedIndex,
						to: observer,
						withKeyPath: keyPath,
						options: nil)
				}

				// See if we have to bind to the selected indexes (multiple)
				// For multiple selection, we have to bind the reverse as well, or else we don't get
				// a two-way binding to the control
				if let observer = self.bindObserver2, let keyPath = self.bindKeyPath2 {
					segmented.bind(
						NSBindingName.SegmentedControlSelectionIndexes,
						to: observer,
						withKeyPath: keyPath,
						options: [NSBindingOption.continuouslyUpdatesValue : NSNumber(value: true)])
					observer.bind(
						NSBindingName(keyPath),
						to: segmented,
						withKeyPath: NSBindingName.SegmentedControlSelectionIndexes.rawValue,
						options: [NSBindingOption.continuouslyUpdatesValue : NSNumber(value: true)])
				}

				self.makeCommon(uiElement: segmented)

				tb.view = segmented
				return tb
			}
		}

		deinit {
			if let control = self._control {
				control.unbind(NSBindingName.selectedIndex)
				control.unbind(NSBindingName.SegmentedControlSelectionIndexes)

				// Remove the reverse binding
				if let observer = self.bindObserver2, let keyPath = self.bindKeyPath2 {
					observer.unbind(NSBindingName(keyPath))
				}

				self.destroyCommon(uiElement: control)
			}
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