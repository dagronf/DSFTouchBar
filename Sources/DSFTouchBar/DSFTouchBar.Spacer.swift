//
//  File.swift
//  
//
//  Created by Darren Ford on 2/2/20.
//

import Foundation

extension DSFTouchBar {
	public class Spacer: Item {

		public enum Size {
			case small
			case large
			case flexible
		}

		public init(size: Size) {
			switch size {
			case .small:
				super.init(ident: .fixedSpaceSmall)
			case .large:
				super.init(ident: .fixedSpaceLarge)
			case .flexible:
				super.init(ident: .flexibleSpace)
			}
		}

		deinit {
			Swift.print("DSFTouchBar.Spacer deinit")
		}
	}
}
