//
//  VehicleExtended.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/03/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation

open class VehicleExtended: Vehicle {

	open var userId: Int?
	open var chargeState: ChargeState?
	open var climateState: ClimateState?
	open var driveState: DriveState?
	open var guiSettings: GuiSettings?
	open var vehicleConfig: VehicleConfig?
	open var vehicleState: VehicleState?
	
	
	private enum CodingKeys: String, CodingKey {
		
		case userId			 = "user_id"
		case chargeState		 = "charge_state"
		case climateState	 = "climate_state"
		case driveState		 = "drive_state"
		case guiSettings		 = "gui_settings"
		case vehicleConfig	 = "vehicle_config"
		case vehicleState	 = "vehicle_state"
	}
	
	required public init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let superdecoder = try container.superDecoder()
		try super.init(from: superdecoder)
		userId = try container.decode(Int?.self, forKey: .userId)
		chargeState = try container.decode(ChargeState?.self, forKey: .chargeState)
		climateState = try container.decode(ClimateState?.self, forKey: .climateState)
		driveState = try container.decode(DriveState?.self, forKey: .driveState)
		guiSettings = try container.decode(GuiSettings?.self, forKey: .guiSettings)
		vehicleConfig = try container.decode(VehicleConfig?.self, forKey: .vehicleConfig)
		vehicleState = try container.decode(VehicleState?.self, forKey: .vehicleState)
	}
	
	public override func encode(to encoder: Encoder) throws {
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(userId, forKey: .userId)
		try container.encode(chargeState, forKey: .chargeState)
		try container.encode(climateState, forKey: .climateState)
		try container.encode(driveState, forKey: .driveState)
		try container.encode(guiSettings, forKey: .guiSettings)
		try container.encode(vehicleConfig, forKey: .vehicleConfig)
		try container.encode(vehicleState, forKey: .vehicleState)
		
		let superdecoder = container.superEncoder()
		try super.encode(to: superdecoder)
	}
	
}
