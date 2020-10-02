//
//  DSFTouchBar.FunctionBuilder.swift
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

// MARK: - TouchBar FunctionBuilder

@_functionBuilder
public struct DSFTouchBarBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}

public extension DSFTouchBarBuilder {
	static func buildBlock(_ settings: DSFTouchBar.Item...) -> [DSFTouchBar.Item] {
		settings
	}
}

public extension DSFTouchBar {
	/// Make a new touchbar using SwiftUI declarative style
	/// - Parameters:
	///   - baseIdentifier: The base identifier for the toolbar
	///   - customizationIdentifier: The customization identifier for the toolbar, or nil for no customization.
	///   - builder: The touchbar items
	/// - Returns: The created toolbar builder
	static func Build(
		baseIdentifier: NSTouchBarItem.Identifier,
		customizationIdentifier: NSTouchBar.CustomizationIdentifier? = nil,
		@DSFTouchBarBuilder builder: () -> [DSFTouchBar.Item]
	) -> DSFTouchBar.Builder {

		let tb = DSFTouchBar.Builder(
			baseIdentifier: baseIdentifier,
			customizationIdentifier: customizationIdentifier,
			children: builder())

		return tb // .toolbar
	}
}

// MARK: - Scroll Group FunctionBuilder

@_functionBuilder
public struct DSFTouchBarScrollGroupBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}

public extension DSFTouchBarScrollGroupBuilder {
	static func buildBlock(_ settings: DSFTouchBar.Item...) -> [DSFTouchBar.Item] {
		settings
	}
}

public extension DSFTouchBar.ScrollGroup {
	convenience init(
		_ leafIdentifier: String,
		customizationLabel: String? = nil,
		@DSFTouchBarScrollGroupBuilder builder: () -> [DSFTouchBar.Item]) {
		self.init(leafIdentifier,
				  customizationLabel: customizationLabel,
				  builder())
	}
}

// MARK: - Popover Group FunctionBuilder

@_functionBuilder
public struct DSFTouchBarScrollPopoverBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}

public extension DSFTouchBarScrollPopoverBuilder {
	static func buildBlock(_ settings: DSFTouchBar.Item...) -> [DSFTouchBar.Item] {
		settings
	}
}

public extension DSFTouchBar.Popover {
	convenience init(
		_ leafIdentifier: String,
		collapsedLabel: String? = nil,
		collapsedImage: NSImage? = nil,
		@DSFTouchBarScrollPopoverBuilder builder: () -> [DSFTouchBar.Item]) {
		self.init(leafIdentifier,
				  collapsedLabel: collapsedLabel,
				  collapsedImage: collapsedImage,
				  builder())
	}
}
