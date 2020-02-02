//
//  AppDelegate.swift
//  Touchbar Tester
//
//  Created by Darren Ford on 2/2/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

