//
//  TabController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

	let service = TeslaSwift.defaultInstance
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		service.useMockServer = false
		service.debuggingEnabled = true
		
		if (!service.isAuthenticated) {
			
			performSegue(withIdentifier: "loginSegue", sender: self)
			
		}
	}
}
