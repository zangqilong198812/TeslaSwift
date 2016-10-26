//
//  VehicleViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 22/10/2016.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit

class VehicleViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	var vehicle: Vehicle?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func getStats(_ sender: AnyObject) {
		if let vehicle = vehicle {
			_ = TeslaSwift.defaultInstance.getVehicleStatus(vehicle).then {
				(details:VehicleDetails) -> Void in
				
				self.textView.text =
					"Battery: \(details.chargeState?.batteryLevel)\n" +
				"firmwareV: \(details.vehicleState?.firmwareVersion)"
				
			}
		}
	}
	
	@IBAction func command(_ sender: AnyObject) {
		if let vehicle = vehicle {
			_ = TeslaSwift.defaultInstance.sendCommandToVehicle(vehicle, command: .lockDoors).then {
				(response:CommandResponse) -> Void in
				self.textView.text = (response.result! ? "true" : "false")
				if let reason = response.reason {
					self.textView.text.append(reason)
				}
			}
		}
	}
    

}
