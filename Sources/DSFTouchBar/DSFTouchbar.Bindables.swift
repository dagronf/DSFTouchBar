//
//  DSFTouchbar.Bindables.swift
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
