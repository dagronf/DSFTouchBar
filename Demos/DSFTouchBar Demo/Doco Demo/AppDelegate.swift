//
//  AppDelegate.swift
//  Doco Demo
//
//  Created by Darren Ford on 1/7/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

