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

#if swift(<5.3)
@_functionBuilder
public struct DSFTouchBarBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}
#else
@resultBuilder
public struct DSFTouchBarBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}
#endif

public extension DSFTouchBarBuilder {
	static func buildBlock(_ settings: DSFTouchBar.Item...) -> [DSFTouchBar.Item] {
		settings
	}
}

// MARK: - Group FunctionBuilder

#if swift(<5.3)
@_functionBuilder
public struct DSFTouchBarGroupBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}
#else
@resultBuilder
public struct DSFTouchBarGroupBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}
#endif

public extension DSFTouchBarGroupBuilder {
	static func buildBlock(_ settings: DSFTouchBar.Item...) -> [DSFTouchBar.Item] {
		settings
	}
}

// MARK: - Scroll Group FunctionBuilder

#if swift(<5.3)
@_functionBuilder
public struct DSFTouchBarScrollGroupBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}
#else
@resultBuilder
public struct DSFTouchBarScrollGroupBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}
#endif

public extension DSFTouchBarScrollGroupBuilder {
	static func buildBlock(_ settings: DSFTouchBar.Item...) -> [DSFTouchBar.Item] {
		settings
	}
}

// MARK: - Popover Group FunctionBuilder

#if swift(<5.3)
@_functionBuilder
public struct DSFTouchBarScrollPopoverBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}
#else
@resultBuilder
public struct DSFTouchBarScrollPopoverBuilder {
	static func buildBlock() -> [DSFTouchBar.Item] { [] }
}
#endif

public extension DSFTouchBarScrollPopoverBuilder {
	static func buildBlock(_ settings: DSFTouchBar.Item...) -> [DSFTouchBar.Item] {
		settings
	}
}
