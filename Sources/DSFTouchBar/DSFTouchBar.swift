//
//  DSFTouchBar.swift
//  Touchbar Tester
//
//  Created by Darren Ford on 28/1/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

import Cocoa

extension NSBindingName {
	static let SegmentedControlSelectionIndexes = NSBindingName("selectedIndexes")
}

class DSFTouchBar: NSObject, NSTouchBarDelegate {

//	static func build(_ children: DSFTouchBar.Item...) -> DSFTouchBar {
//		let newView = DSFTouchBar()
//
//		for item in children {
//			newView.add(item: item)
//		}
//
//		return newView
//	}

	deinit {
		Swift.print("Cleanup")
	}

	private let mainBar = NSTouchBar()

	private var items: [DSFTouchBar.Item] = []
	private var keys: [NSTouchBarItem.Identifier] {
		return items.map { $0.identifier }
	}
	func item(for identifier: NSTouchBarItem.Identifier) -> DSFTouchBar.Item? {
		return self.items.filter { $0.identifier == identifier }.first
	}

	init(_ children: DSFTouchBar.Item...) {
		super.init()
		for item in children {
			self.add(item: item)
		}
	}


	var touchBar: NSTouchBar? {
		return self.mainBar
	}

	var defaultItems: [NSTouchBarItem.Identifier] {
		return self.keys
	}

	func makeTouchBar() -> NSTouchBar? {
		self.mainBar.delegate = self
		self.mainBar.defaultItemIdentifiers = self.defaultItems
		return self.mainBar
	}

	func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
		guard let item = self.item(for: identifier) else {
			return nil
		}

		return item.maker?()
	}

	func add(item: DSFTouchBar.Item) {
		if let i = item as? DSFTouchBar.Group {
			for item in i._children {
				self.items.append(item)
			}
		}
		else {
			self.items.append(item)
		}
	}


}

extension DSFTouchBar {

	class Item {
		let identifier: NSTouchBarItem.Identifier
		var touchbarItem: NSTouchBarItem?

		var parent: DSFTouchBar.Popover? = nil

		init(ident: NSTouchBarItem.Identifier) {
			self.identifier = ident
		}

		var maker: (() -> NSTouchBarItem?)? = nil
	}

	class UIElementItem<T>: Item where T: NSControl {
		fileprivate var _control: T?

		private var _onCreate: ((T) -> Void)? = nil
		func onCreate(_ block: @escaping (T) -> Void) -> UIElementItem<T> {
			_onCreate = block
			return self
		}

		private var _onDestroy: ((T) -> Void)? = nil
		func onDestroy(_ block: @escaping (T) -> Void) -> UIElementItem<T> {
			_onDestroy = block
			return self
		}

		private var bindVisibilityObserver: Any? = nil
		private var bindVisibilityKeyPath: String? = nil
		func bindVisibility<T>(to observable: Any, withKeyPath keyPath: String) -> T {
			self.bindVisibilityObserver = observable
			self.bindVisibilityKeyPath = keyPath
			return self as! T
		}

		private var _width: CGFloat?
		public func width<T>(_ width: CGFloat?) -> T {
			_width = width
			return self as! T
		}

		// Create the common elements of this item
		fileprivate func makeCommon(uiElement: T) {

			self._control = uiElement

			// Width

			if let w = self._width {
				let hconstraints = [
					NSLayoutConstraint.init(item: uiElement, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: w)
				]
				NSLayoutConstraint.activate(hconstraints)
			}

			// Visibility

			if uiElement.exposedBindings.contains(NSBindingName.visible),
				let observer = self.bindVisibilityObserver,
				let keyPath = self.bindVisibilityKeyPath {
					uiElement.bind(NSBindingName.visible,
								to: observer,
								withKeyPath: keyPath,
								options: nil)
			}

			if let contr = self._onCreate {
				contr(uiElement)
			}
		}

		func destroyCommon(uiElement: T) {
			uiElement.unbind(NSBindingName.visible)
			if let destroyCallback = self._onDestroy {
				destroyCallback(uiElement)
			}
			self._control = nil
		}

	}

	class Button: UIElementItem<NSButton> {

		//private var _button: NSButton?

		private var _attributedTitle: NSAttributedString?
		func attributedTitle(_ title: NSAttributedString) -> Button {
			_attributedTitle = title
			return self
		}

		private var _title: String = "Button"
		func title(_ title: String) -> Button {
			_title = title
			return self
		}

		private var _alternateTitle: String = ""
		func alternateTitle(_ alternateTitle: String) -> Button {
			_alternateTitle = alternateTitle
			return self
		}

		private var _image: NSImage?
		func image(_ image: NSImage?) -> Button {
			_image = image
			return self
		}

		private var _color: NSColor?
		func color(_ color: NSColor?) -> Button {
			_color = color
			return self
		}

		private var _action: ((NSControl.StateValue) -> Void)?
		func action(_ action: @escaping ((NSControl.StateValue) -> Void)) -> Button {
			_action = action
			return self
		}

		private var bindObserver: Any? = nil
		private var bindKeyPath: String? = nil
		func bindState(to observable: Any, withKeyPath keyPath: String) -> Button {
			self.bindObserver = observable
			self.bindKeyPath = keyPath
			return self
		}

		init(identifier: String, type: NSButton.ButtonType = .momentaryLight) { //, label: String, image: NSImage? = nil) {
			super.init(ident: NSTouchBarItem.Identifier(identifier))

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				let tb = NSCustomTouchBarItem(identifier: self.identifier)

				let button = NSButton(title: self._title, target: self, action: #selector(self.act(_:)))

				button.translatesAutoresizingMaskIntoConstraints = false
				button.image = self._image
				button.bezelColor = self._color
				button.setButtonType(type)

				if let att = self._attributedTitle {
					button.attributedTitle = att
				}

				// If the button type is not an 'on off' type, then the value binding doesn't
				// exist for the button.  We need to check first.
				if button.exposedBindings.contains(NSBindingName.value),
					let observer = self.bindObserver,
					let keyPath = self.bindKeyPath {
						button.bind(NSBindingName.value,
									to: observer,
									withKeyPath: keyPath,
									options: nil)
				}

				self.makeCommon(uiElement: button)
				tb.view = button

				return tb
			}
		}

		deinit {
			if let but = self._control {
				but.unbind(NSBindingName.value)
				self.destroyCommon(uiElement: but)
			}
		}

		@objc public func act(_ sender: NSButton) {

			if _alternateTitle.count > 0 {
				sender.title = (sender.state == .on) ? self._alternateTitle : self._title
			}

			self._action?(sender.state)
		}
	}

	class Text: UIElementItem<NSTextField> {
		private var _label: String = "Text"
		func label(_ label: String) -> Text {
			_label = label
			return self
		}

		private var bindObserver: Any? = nil
		private var bindKeyPath: String? = nil
		func bindValue(to observable: Any, withKeyPath keyPath: String) -> Text {
			self.bindObserver = observable
			self.bindKeyPath = keyPath
			return self
		}

		init(identifier: String, label: String ) { //, label: String, image: NSImage? = nil) {
			self._label = label
			super.init(ident: NSTouchBarItem.Identifier(identifier))

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				let tb = NSCustomTouchBarItem(identifier: self.identifier)
				let field = NSTextField(labelWithString: label)
				field.translatesAutoresizingMaskIntoConstraints = false
				tb.view = field

				if let observer = self.bindObserver,
					let keyPath = self.bindKeyPath,
					field.exposedBindings.contains(NSBindingName.value) {
					field.bind(NSBindingName.value,
								   to: observer,
								   withKeyPath: keyPath,
								   options: nil)
				}

				self.makeCommon(uiElement: field)
				return tb
			}
		}
		deinit {
			if let field = self._control {
				field.unbind(NSBindingName.value)
				self.destroyCommon(uiElement: field)
			}
		}
	}

	class Group: Item {
		var _children: [DSFTouchBar.Item] = []
		private var _equalWidths: Bool = false

		init(identifier: String, equalWidths: Bool = false, _ children: [DSFTouchBar.Item]) {
			_children = children
			_equalWidths = equalWidths
			super.init(ident: NSTouchBarItem.Identifier(identifier))

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}
				let groupItems = self._children.compactMap { $0.maker?() }
				let tb = NSGroupTouchBarItem(identifier: NSTouchBarItem.Identifier(identifier), items: groupItems)
				tb.prefersEqualWidths = self._equalWidths
				return tb
			}

		}
	}

	class Popover: Item {

		private var popoverContent: DSFTouchBar? = nil

		private(set) var _children: [DSFTouchBar.Item] = []
		init(identifier: String,
			 collapsedLabel: String? = nil,
			 collapsedImage: NSImage? = nil,
			 _ children: [DSFTouchBar.Item]) {
			_children = children
			super.init(ident: NSTouchBarItem.Identifier(identifier))

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				self.popoverContent = nil
				let pc = DSFTouchBar()

				for item in self._children {
					pc.add(item: item)
				}

				let tb = NSPopoverTouchBarItem(identifier: NSTouchBarItem.Identifier(identifier))
				if let label = collapsedLabel {
					tb.collapsedRepresentationLabel = label
				}
				tb.collapsedRepresentationImage = collapsedImage

				if let mtb = pc.makeTouchBar() {
					tb.popoverTouchBar = mtb
				}

				self.popoverContent = pc

				return tb
			}

		}
	}

	class Slider: UIElementItem<NSSlider> {

		private var _action: ((CGFloat) -> Void)?
		func action(_ action: @escaping ((CGFloat) -> Void)) -> Slider {
			_action = action
			return self
		}

		private var _label: String?
		func label(_ label: String) -> Slider {
			_label = label
			return self
		}

		private var _minAccessoryImage: NSImage?
		func minimumValueAccessory(image: NSImage?) -> Slider {
			_minAccessoryImage = image
			return self
		}

		private var _maxAccessoryImage: NSImage?
		func maximumValueAccessory(image: NSImage?) -> Slider {
			_maxAccessoryImage = image
			return self
		}

		private var bindObserver: Any? = nil
		private var bindKeyPath: String? = nil
		func bindValue(to observable: Any, withKeyPath keyPath: String) -> Slider {
			self.bindObserver = observable
			self.bindKeyPath = keyPath
			return self
		}

		init(identifier: String, min: CGFloat, max: CGFloat) {
			assert(min < max)
			super.init(ident: NSTouchBarItem.Identifier(identifier))

			self.maker = { [weak self] in
				guard let `self` = self else {
					return nil
				}

				let tb = NSSliderTouchBarItem(identifier: self.identifier)
				tb.label = self._label
				tb.action = #selector(self.act(_:))
				tb.target = self
				tb.slider.minValue = Double(min)
				tb.slider.maxValue = Double(max)
				if let minImage = self._minAccessoryImage {
					tb.minimumValueAccessory = NSSliderAccessory(image: minImage)
				}
				if let maxImage = self._maxAccessoryImage {
					tb.maximumValueAccessory = NSSliderAccessory(image: maxImage)
				}

				if let observer = self.bindObserver,
					let keyPath = self.bindKeyPath {
					tb.slider.bind(NSBindingName.value,
								   to: observer,
								   withKeyPath: keyPath,
								   options: nil)
				}

				// Init the common elements, and call the create callback if needed
				self.makeCommon(uiElement: tb.slider)

				return tb
			}
		}

		deinit {
			if let slider = self._control {
				slider.unbind(NSBindingName.value)

				self.destroyCommon(uiElement: slider)
			}
		}

		@objc public func act(_ slider: Any?) {
			if let action = self._action,
				let s = slider as? NSSliderTouchBarItem {
				let ee = s.slider.doubleValue
				action(CGFloat(ee))
			}
		}
	}

	class Segmented: UIElementItem<NSSegmentedControl> {

		private var _action: (([Int]) -> Void)?
		private var _segments: [(label: String?, image: NSImage?)] = []
		private var _selectedColor: NSColor?

		/// Assign an action block to the touchbar item to be called when the control changes state
		func action(_ action: @escaping (([Int]) -> Void)) -> Segmented {
			_action = action
			return self
		}

		/// Add a new segment button to the segmented control
		/// - Parameters:
		///   - label: (optional) the text to use for the segmented cell
		///   - image: (optional) the image to use for the segmented cell
		func add(label: String? = nil, image: NSImage? = nil) -> Segmented {

			// Must specify label, image or both
			assert(label != nil || image != nil)
			_segments.append((label, image))
			return self
		}


		/// Set the color to use for highlighting 'active' cells within the control
		/// - Parameter color: The color to use
		func selectedColor(_ color: NSColor) -> Segmented {
			_selectedColor = color
			return self
		}

		private var bindObserver: Any? = nil
		private var bindKeyPath: String? = nil
		func bindSelectedIndex(to observable: Any, withKeyPath keyPath: String) -> Segmented {
			self.bindObserver = observable
			self.bindKeyPath = keyPath
			return self
		}

		private var bindObserver2: AnyObject? = nil
		private var bindKeyPath2: String? = nil
		func bindSelectionIndexes(to observable: AnyObject, withKeyPath keyPath: String) -> Segmented {
			self.bindObserver2 = observable
			self.bindKeyPath2 = keyPath
			return self
		}

		init(identifier: String, trackingMode: NSSegmentedControl.SwitchTracking = .selectOne ) {
			super.init(ident: NSTouchBarItem.Identifier(identifier))

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
				if let observer = self.bindObserver, let keyPath = self.bindKeyPath {
					segmented.bind(NSBindingName.selectedIndex,
								   to: observer,
								   withKeyPath: keyPath,
								   options: nil)
				}

				// See if we have to bind to the selected indexes (multiple)
				// For multiple selection, we have to bind the reverse as well, or else we don't get
				// a two-way binding to the control
				if let observer = self.bindObserver2, let keyPath = self.bindKeyPath2 {
					segmented.bind(NSBindingName.SegmentedControlSelectionIndexes,
								   to: observer,
								   withKeyPath: keyPath,
								   options: [NSBindingOption.continuouslyUpdatesValue : NSNumber(value: true)])
					observer.bind(NSBindingName(keyPath),
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
