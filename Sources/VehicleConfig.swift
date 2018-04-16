//
//  VehicleConfig.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/03/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation

open class VehicleConfig: Codable {
	
	open var canActuateTrunks: Bool?
	open var carSpecialType: String?
	open var carType: String?
	open var chargePortType: String?
	open var euVehicle: Bool?
	open var exteriorColor: String?
	open var hasLudicoursMode: Bool?
	open var motorizedChargePort: Bool?
	open var perfConfig: String?
	open var plg: Bool?
	private var rearSeatHeatersBool: Int?
	open var rearSeatHeaters: Bool? { return rearSeatHeatersBool == 1 }
	open var rearSeatType: Int?
	open var rhd: Bool?
	open var roofColor: String? // "None" for panoramic roof
	open var seatType: Int?
	open var spoilerType: String?
	open var sunRoofInstalled: Int?
	open var thirdRowSeats: String?
	open var timeStamp: TimeInterval?
	open var trimBadging: String?
	open var wheelType: String?

	enum CodingKeys: String, CodingKey {
		
		case canActuateTrunks	= "can_actuate_trunks"
		case carSpecialType		 = "car_special_type"
		case carType				 = "car_type"
		case chargePortType			= "charge_port_type"
		case euVehicle			 = "eu_vehicle"
		case exteriorColor		 = "exterior_color"
		case hasLudicoursMode	 = "has_ludicrous_mode"
		case motorizedChargePort  = "motorized_charge_port"
		case perfConfig			 = "perf_config"
		case plg				= "plg"
		case rearSeatHeatersBool		 = "rear_seat_heaters"
		case rearSeatType		 = "rear_seat_type"
		case rhd					 = "rhd"
		case roofColor			 = "roof_color"
		case seatType			 = "seat_type"
		case spoilerType			 = "spoiler_type"
		case sunRoofInstalled	 = "sun_roof_installed"
		case thirdRowSeats		 = "third_row_seats"
		case timeStamp			= "timestamp"
		case trimBadging			 = "trim_badging"
		case wheelType			 = "wheel_type"
	}
	
}
