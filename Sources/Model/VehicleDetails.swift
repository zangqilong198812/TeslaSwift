//
//  VehicleState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 06/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

open class VehicleDetails {

	open internal(set) var mobileAccess: Bool?
	open internal(set) var chargeState: ChargeState?
	open internal(set) var climateState: ClimateState?
	open internal(set) var driveState: DriveState?
	open internal(set) var guiSettings: GuiSettings?
	open internal(set) var vehicleState: VehicleState?
}
