//
//  VehicleViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 22/10/2016.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit
import CoreLocation

class VehicleViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	var vehicle: Vehicle?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func getVehicle(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let vehicle2 = try await api.getVehicle(vehicle)
            self.textView.text = "Inside temp: \(vehicle2.jsonString!)"
        }
    }
    
    @IBAction func getTemps(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let climateState = try await api.getVehicleClimateState(vehicle)
            self.textView.text = "Inside temp: \(String(describing: climateState.insideTemperature?.celsius))\n" +
            climateState.jsonString!
        }
	}

	@IBAction func getChargeState(_ sender: AnyObject) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let chargeState = try await api.getVehicleChargeState(vehicle)
            self.textView.text = "Battery: \(chargeState.batteryLevel!) % (\(chargeState.idealBatteryRange!.kms) km)\n" +
            "charge rate: \(chargeState.chargeRate!.kilometersPerHour) km/h\n" +
            "energy added: \(chargeState.chargeEnergyAdded!) kWh\n" +
            "distance added (ideal): \(chargeState.chargeDistanceAddedIdeal!.kms) km\n" +
            "power: \(chargeState.chargerPower ?? 0) kW\n" +
            "\(chargeState.chargerVoltage ?? 0)V \(chargeState.chargerActualCurrent ?? 0)A\n" +
            "charger max current: \(String(describing: chargeState.chargerPilotCurrent))\n\(chargeState.jsonString!)"

        }
	}

	@IBAction func getVehicleState(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let vehicleState = try await api.getVehicleState(vehicle)
            self.textView.text = "FW: \(String(describing: vehicleState.firmwareVersion))\n" +
            vehicleState.jsonString!
        }
	}

	@IBAction func getDriveState(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let driveState = try await api.getVehicleDriveState(vehicle)
            self.textView.text = "Location: \(String(describing: driveState.position))\n" +
            driveState.jsonString!
        }
	}

	@IBAction func getGUISettings(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let guiSettings = try await api.getVehicleGuiSettings(vehicle)
            self.textView.text = "Charge rate units: \(String(describing: guiSettings.chargeRateUnits))\n" +
            guiSettings.jsonString!
        }
	}
	
	@IBAction func gettAll(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let extendedVehicle = try await api.getAllData(vehicle)
            self.textView.text = "All data:\n" +
            extendedVehicle.jsonString!
        }
	}
	
	
	@IBAction func getConfig(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let config = try await api.getVehicleConfig(vehicle)
            self.textView.text = "All data:\n" +
            config.jsonString!
        }
	}
	
	@IBAction func command(_ sender: AnyObject) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let response = try await api.sendCommandToVehicle(vehicle, command: .setMaxDefrost(on: false))
            self.textView.text = (response.result! ? "true" : "false")
            if let reason = response.reason {
                self.textView.text.append(reason)
            }
        }
	}
	
	@IBAction func wakeup(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let response = try await api.wakeUp(vehicle)
            self.textView.text = response.state
        }
    }
	
	
	@IBAction func speedLimit(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let response = try await api.sendCommandToVehicle(vehicle, command: .speedLimitClearPin(pin: "1234"))
            self.textView.text = (response.result! ? "true" : "false")
            if let reason = response.reason {
                self.textView.text.append(reason)
            }
        }
	}

    @IBAction func getNearbyChargingSites(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let nearbyChargingSites = try await api.getNearbyChargingSites(vehicle)
            self.textView.text = "NearbyChargingSites:\n" +
            nearbyChargingSites.jsonString!
        }
    }

    @IBAction func refreshToken(_ sender: Any) {
        Task { @MainActor in
            do {
                let token = try await api.refreshWebToken()
                self.textView.text = "New access Token:\n \(token)"
            } catch {
                self.textView.text = "Refresh Token:\n CATCH"
            }
        }
    }

    @IBAction func ampsTo16(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let response = try await api.sendCommandToVehicle(vehicle, command: .setCharging(amps: 16))
            self.textView.text = (response.result! ? "true" : "false")
            if let reason = response.reason {
                self.textView.text.append(reason)
            }
        }
    }

    @IBAction func revokeToken(_ sender: Any) {
        Task { @MainActor in
            do {
                let status = try await api.revokeWeb()
                self.textView.text = "Revoked: \(status)"
            } catch {
                self.textView.text = "Revoke Token:\n CATCH"
            }
        }
    }

    @IBAction func logout(_ sender: Any) {
        api.logout()
    }
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		if segue.identifier == "toStream" {
			
			let vc = segue.destination as! StreamViewController
			vc.vehicle = self.vehicle
		}
	}


}
