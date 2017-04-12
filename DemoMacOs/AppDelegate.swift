//
//  AppDelegate.swift
//  DemoMacOs
//
//  Created by Joao Nunes on 04/02/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var api = TeslaSwift()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

