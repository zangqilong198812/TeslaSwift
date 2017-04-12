//
//  VehicleExtended.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/03/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

open class VehicleExtended: Vehicle {

	open var userId: Int?
	open var chargeState: ChargeState?
	open var climateState: ClimateState?
	open var driveState: DriveState?
	open var guiSettings: GuiSettings?
	open var vehicleConfig: VehicleConfig?
	open var vehicleState: VehicleState?
	
	
	open override func mapping(map: Map) {
		super.mapping(map: map)
		
		userId			<- map["user_id"]
		chargeState		<- map["charge_state"]
		climateState	<- map["climate_state"]
		driveState		<- map["drive_state"]
		guiSettings		<- map["gui_settings"]
		vehicleConfig	<- map["vehicle_config"]
		vehicleState	<- map["vehicle_state"]
	}
	
}
