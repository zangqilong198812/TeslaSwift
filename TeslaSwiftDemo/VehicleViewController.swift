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
	
	@IBAction func getTemps(_ sender: Any) {
		if let vehicle = vehicle {
			_ = api.getVehicleClimateState(vehicle).then {
				(climateState: ClimateState) -> Void in
				self.textView.text = "Inside temp: \(climateState.insideTemperature?.celsius)\n"
			}
		}
		
	}
	@IBAction func getChargeState(_ sender: AnyObject) {
		if let vehicle = vehicle {
			_ = api.getVehicleChargeState(vehicle).then {
				(chargeState: ChargeState) -> Void in
				
				self.textView.text = "Battery: \(chargeState.batteryLevel) %\n"
				
				}
		}
	}
	@IBAction func getVehicleState(_ sender: Any) {
			if let vehicle = vehicle {
				_ = self.api.getVehicleState(vehicle).then(execute: { (vehicleState: VehicleState) -> Void in
					
					self.textView.text = self.textView.text + "FW: \(vehicleState.firmwareVersion)\n"
				})
		}
		
	}
	@IBAction func getDriveState(_ sender: Any) {
		
		if let vehicle = vehicle {
			_ = api.getVehicleDriveState(vehicle).then {
				(driveState: DriveState) -> Void in
				
				self.textView.text = "Location: \(driveState.position)"
				
			}
		}
		
	}
	@IBAction func getGUISettings(_ sender: Any) {
		if let vehicle = vehicle {
			_ = api.getVehicleGuiSettings(vehicle).then(execute: { (guiSettings: GuiSettings) -> Void in
				self.textView.text = "Charge rate units: \(guiSettings.chargeRateUnits)"
				
				
			})
		}
		
	}
	
	@IBAction func command(_ sender: AnyObject) {
		if let vehicle = vehicle {
			_ = api.sendCommandToVehicle(vehicle, command: .lockDoors).then {
				(response:CommandResponse) -> Void in
				self.textView.text = (response.result! ? "true" : "false")
				if let reason = response.reason {
					self.textView.text.append(reason)
				}
			}
		}
	}
    

}
