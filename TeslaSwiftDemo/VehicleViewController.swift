//
//  VehicleViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 22/10/2016.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit
import ObjectMapper

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
				self.textView.text = "Inside temp: \(climateState.insideTemperature?.celsius)\n" +
					climateState.toJSONString()!
			}
		}
		
	}
	@IBAction func getChargeState(_ sender: AnyObject) {
		if let vehicle = vehicle {
			_ = api.getVehicleChargeState(vehicle).then {
				(chargeState: ChargeState) -> Void in
				
				self.textView.text = "Battery: \(chargeState.batteryLevel!) % (\(chargeState.idealBatteryRange!.kms) km)\n" +
				"charge rate: \(chargeState.chargeRate!.kms) km/h\n" +
				"energy added: \(chargeState.chargeEnergyAdded!) kWh\n" +
				"distance added (ideal): \(chargeState.chargeDistanceAddedIdeal!.kms) km\n" +
				"power: \(chargeState.chargerPower!) kW\n" +
				"\(chargeState.chargerVoltage!)V \(chargeState.chargerActualCurrent!)A\n" +
				"charger max current: \(chargeState.chargerPilotCurrent)\n\(chargeState.toJSONString()!)"
				
				return ()
				}
		}
	}
	@IBAction func getVehicleState(_ sender: Any) {
			if let vehicle = vehicle {
				_ = self.api.getVehicleState(vehicle).then(execute: { (vehicleState: VehicleState) -> Void in
					
					self.textView.text = "FW: \(vehicleState.firmwareVersion)\n" +
					vehicleState.toJSONString()!

				})
		}
		
	}
	@IBAction func getDriveState(_ sender: Any) {
		
		if let vehicle = vehicle {
			_ = api.getVehicleDriveState(vehicle).then {
				(driveState: DriveState) -> Void in
				
				self.textView.text = "Location: \(driveState.position)\n" +
					driveState.toJSONString()!
				
			}
		}
		
	}
	@IBAction func getGUISettings(_ sender: Any) {
		if let vehicle = vehicle {
			_ = api.getVehicleGuiSettings(vehicle).then(execute: { (guiSettings: GuiSettings) -> Void in
				self.textView.text = "Charge rate units: \(guiSettings.chargeRateUnits)\n" +
					guiSettings.toJSONString()!

				
				
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
