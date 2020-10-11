//
//  DSFTouchBar.Bindables.swift
//  DSFTouchBar
//
//  Created by Darren Ford on 25/9/20.
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

/// A typed object binding container, bound using addObserver
internal class BindableTypedAttribute<VALUETYPE>: NSObject {
	// The value of the attribute
	var value: VALUETYPE?

	private(set) weak var bindValueObserver: NSObject?
	private var bindStringKeyPath: String?

	private var valueChangeCallback: ((VALUETYPE) -> Void)?

	/// Has this attribute been bound to an observer?
	public private(set) var bindingIsActive: Bool = false

	func setup<TYPE>(observable: NSObject, keyPath: ReferenceWritableKeyPath<TYPE, VALUETYPE>) {
		self.bindValueObserver = observable

		// This is a little bit of a cheeky solution.  The internal 'addObserver' methods
		// use string-based keyPaths which are not typesafe.
		// As long as the object being observed (observable) is an @objc-defined object we can convert the
		// ReferenceWritableKeyPath to a String using NSExpression.
		// It's probably an abuse of the system, but it does allow us to make the interface type-safe
		// (which is useful because sometimes the bindable type is not clear, such
		// as NSSet for NSSegmentedControl.selected)
		let stringKeyPath = NSExpression(forKeyPath: keyPath).keyPath
		guard !stringKeyPath.isEmpty else {
			fatalError("Unable to convert keyPath \(keyPath)")
		}
		self.bindStringKeyPath = stringKeyPath
	}

	func updateValue(_ newValue: VALUETYPE) {
		guard let observer = self.bindValueObserver,
			  let keyPath = self.bindStringKeyPath else {
			// No binding was set for the attribute
			return
		}
		observer.setValue(newValue, forKey: keyPath)
	}

	func bind(valueChangeCallback: @escaping (VALUETYPE) -> Void) {

		if self.bindingIsActive == true {
			/// There's already a binding. Replace the callback
			self.valueChangeCallback = valueChangeCallback
			return
		}

		guard let observer = self.bindValueObserver,
			  let strKeyPath = self.bindStringKeyPath else {
			// No binding was set for the attribute
			return
		}

		self.valueChangeCallback = valueChangeCallback

		observer.addObserver(self, forKeyPath: strKeyPath, options: [.new], context: nil)
		self.bindingIsActive = true

		// Set the initial value from the binding if we can
		if let v = observer.value(forKeyPath: strKeyPath) as? VALUETYPE {
			valueChangeCallback(v)
		}
	}

	func unbind() {
		if !self.bindingIsActive {
			return
		}

		if let observer = self.bindValueObserver,
		   let strKeyPath = self.bindStringKeyPath {
			observer.removeObserver(self, forKeyPath: strKeyPath)
			self.bindingIsActive = false
		}
	}

	override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if let changeCallback = self.valueChangeCallback,
		   let observerKeyPath = self.bindStringKeyPath,
		   observerKeyPath == keyPath,
		   let newVal = change?[.newKey] as? VALUETYPE {
			changeCallback(newVal)
		}
		else {
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
		}
	}
}


/// Binding class for observed objects that can use NSBindingName
class BindableAttributeBinding<VALUETYPE>: NSObject {
	var value: VALUETYPE?

	private var continuouslyUpdatesValue = true

	private(set) weak var bindValueObserver: AnyObject?
	private(set) var bindValueKeyPath: String?

	// The object to observe
	private(set) var boundObject: AnyObject?

	// The name of the binding type (eg. "value", "selectedItems" etc)
	private(set) var bindingName: NSBindingName?

	func setup<CLASSTYPE>(observable: NSObject, keyPath: ReferenceWritableKeyPath<CLASSTYPE, VALUETYPE>, continuouslyUpdates: Bool = true) {
		self.bindValueObserver = observable

		// Convert the key path to a string version of it.  This ONLY works iff observable is an @objc dynamic var object.
		let stringKeyPath = NSExpression(forKeyPath: keyPath).keyPath
		guard !stringKeyPath.isEmpty else {
			fatalError("Unable to convert keyPath \(keyPath)")
		}

		self.bindValueKeyPath = stringKeyPath
		self.continuouslyUpdatesValue = continuouslyUpdates
	}


	/// Bind the object
	/// - Parameters:
	///   - bindingName: The name of the binding to observe
	///   - boundObject: The observable object
	///   - checkAvailability: if true, performs a check to make sure that the receiver has exposed the binding 'bindingName'
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
}
