//
//  AppDelegate.swift
//  DSFTouchBar Demo
//
//  Created by Darren Ford on 7/9/20.
//

import Cocoa

import DSFTouchBar

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet var window: NSWindow!


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true

		// turn on memory logging to make sure we're cleaning up
		DSFTouchBar.EnableLogging(true)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
}
