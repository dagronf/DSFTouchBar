//
//  DSFTouchbar.Bindables.swift
//
//  Created by Darren Ford on 18/9/20.
//

import AppKit

class BindableAttribute<VALUETYPE>: NSObject {
	// The value of the attribute
	var value: VALUETYPE?

	private(set) weak var bindValueObserver: AnyObject?
	private(set) var bindValueKeyPath: String?

	private var valueChangeCallback: ((VALUETYPE) -> Void)?

	func setup(observable: AnyObject, keyPath: String) {
		self.bindValueObserver = observable
		self.bindValueKeyPath = keyPath
	}

	func bind(valueChangeCallback: @escaping (VALUETYPE) -> Void) {
		guard let observer = self.bindValueObserver,
			  let keyPath = self.bindValueKeyPath else {
			// No binding was set for the attribute
			return
		}

		self.valueChangeCallback = valueChangeCallback

		observer.addObserver(self, forKeyPath: keyPath, options: [.new], context: nil)

		// Set the initial value from the binding if we can
		if let v = observer.value(forKeyPath: keyPath) as? VALUETYPE {
			valueChangeCallback(v)
		}
	}

	func unbind() {
		if let observer = self.bindValueObserver,
		   let keyPath = self.bindValueKeyPath {
			observer.removeObserver(self, forKeyPath: keyPath)
		}
	}

	override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if let changeCallback = self.valueChangeCallback,
		   let observerKeyPath = self.bindValueKeyPath, observerKeyPath == keyPath,
		   let newVal = change?[.newKey] as? VALUETYPE {
			changeCallback(newVal)
		}
		else {
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
		}
	}
}

// Binding class for observed objects that can use NSBindingName
class BindableBinding<VALUETYPE>: NSObject {
	var value: VALUETYPE?

	private var continuouslyUpdatesValue = true

	private(set) weak var bindValueObserver: AnyObject?
	private(set) var bindValueKeyPath: String?

	// This is something like an NSTextField
	private(set) var boundObject: AnyObject?
	private(set) var bindingName: NSBindingName?

	func setup(observable: AnyObject, keyPath: String, continuouslyUpdates: Bool = true) {
		self.bindValueObserver = observable
		self.bindValueKeyPath = keyPath
		self.continuouslyUpdatesValue = continuouslyUpdates
	}

	func bind(bindingName: NSBindingName, of boundObject: NSObject, checkAvailability: Bool = true) {
		self.bindingName = bindingName

		if checkAvailability, !boundObject.exposedBindings.contains(bindingName) {
			return
		}

		guard let observer = self.bindValueObserver,
			  let keyPath = self.bindValueKeyPath else {
			return
		}
		self.boundObject = boundObject

		var options = [NSBindingOption: Any]()
		if continuouslyUpdatesValue {
			options[NSBindingOption.continuouslyUpdatesValue] = NSNumber(value: true)
		}

		boundObject.bind(
			bindingName,
			to: observer,
			withKeyPath: keyPath,
			options: options.count == 0 ? nil : options)
	}

	func reverseBind() {
		guard let observer = self.bindValueObserver,
			  let keyPath = self.bindValueKeyPath,
			  let boundObject = self.boundObject,
			  let bindingName = self.bindingName else {
			return
		}

		var options = [NSBindingOption: Any]()
		if continuouslyUpdatesValue {
			options[NSBindingOption.continuouslyUpdatesValue] = NSNumber(value: true)
		}

		observer.bind(
			NSBindingName(keyPath),
			to: boundObject,
			withKeyPath: bindingName.rawValue,
			options: options.count == 0 ? nil : options)
	}

	func unbind() {
		if let boundObject = self.boundObject,
		   let bindingName = self.bindingName {
			boundObject.unbind(bindingName)
			self.boundObject = nil
		}

		if let keyPath = self.bindValueKeyPath,
		   let observer = self.bindValueObserver {
			observer.unbind(NSBindingName(keyPath))
		}
	}

	let eee = NegateValueTransformer()
	class NegateValueTransformer: ValueTransformer {
		override class func transformedValueClass() -> AnyClass {
			return NSNumber.self
		}

		override func transformedValue(_ value: Any?) -> Any? {
			guard let v = value as? NSNumber else {
				return NSNumber(value: false)
			}
			return NSNumber(value: !v.boolValue)
		}
	}
}
