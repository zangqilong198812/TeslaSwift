//
//  VehicleState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 06/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class VehicleDetails {

	public internal(set) var mobileAccess: Bool?
	public internal(set) var chargeState: ChargeState?
	public internal(set) var climateState: ClimateState?
	public internal(set) var driveState: DriveState?
	public internal(set) var guiSettings: GuiSettings?
	public internal(set) var vehicleState: VehicleState?
}
