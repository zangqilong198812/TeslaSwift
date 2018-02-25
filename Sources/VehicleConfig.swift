//
//  VehicleConfig.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/03/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation

open class VehicleConfig: Codable {
	
	private var canActuateTrunksBool: Int?
	open var canActuateTrunks: Bool? { return canActuateTrunksBool == 1 }
	open var carSpecialType: String?
	open var carType: String?
	open var chargePortType: String?
	private var euVehicleBool: Int?
	open var euVehicle: Bool? { return euVehicleBool == 1 }
	open var exteriorColor: String?
	private var hasLudicoursModeBool: Int?
	open var hasLudicoursMode: Bool? { return hasLudicoursModeBool == 1 }
	private var motorizedChargePortBool: Int?
	open var motorizedChargePort: Bool? { return motorizedChargePortBool == 1 }
	open var perfConfig: String?
	open var plg: Int?
	private var rearSeatHeatersBool: Int?
	open var rearSeatHeaters: Bool? { return rearSeatHeatersBool == 1 }
	open var rearSeatType: Int?
	private var rhdBool: Int?
	open var rhd: Bool? { return rhdBool == 1 }
	open var roofColor: String? // "None" for panoramic roof
	open var seatType: Int?
	open var spoilerType: String?
	private var sunRoofInstalledBool: Int?
	open var sunRoofInstalled: Bool? { return sunRoofInstalledBool == 1 }
	open var thirdRowSeats: String?
	open var timeStamp: TimeInterval?
	open var trimBadging: String?
	open var wheelType: String?

	enum CodingKeys: String, CodingKey {
		
		case canActuateTrunksBool	= "can_actuate_trunks"
		case carSpecialType		 = "car_special_type"
		case carType				 = "car_type"
		case chargePortType			= "charge_port_type"
		case euVehicleBool			 = "eu_vehicle"
		case exteriorColor		 = "exterior_color"
		case hasLudicoursModeBool	 = "has_ludicrous_mode"
		case motorizedChargePortBool  = "motorized_charge_port"
		case perfConfig			 = "perf_config"
		case plg				= "plg"
		case rearSeatHeatersBool		 = "rear_seat_heaters"
		case rearSeatType		 = "rear_seat_type"
		case rhdBool					 = "rhd"
		case roofColor			 = "roof_color"
		case seatType			 = "seat_type"
		case spoilerType			 = "spoiler_type"
		case sunRoofInstalledBool	 = "sun_roof_installed"
		case thirdRowSeats		 = "third_row_seats"
		case timeStamp			= "timestamp"
		case trimBadging			 = "trim_badging"
		case wheelType			 = "wheel_type"
	}
	
}
