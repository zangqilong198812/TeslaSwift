//
//  VehicleConfig.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/03/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation

open class VehicleConfig: Codable {
	
	open var carSpecialType: String?
	open var carType: String?
	open var euVehicle: Bool?
	open var exteriorColor: String?
	open var hasLudicoursMode: Bool?
	open var motorizedChargePort: Bool?
	open var perfConfig: String?
	open var plg: Int?
	open var rearSeatHeaters: Bool?
	open var rearSeatType: Int?
	open var rhd: Bool?
	open var roofColor: String? // "None" for panoramic roof
	open var seatType: Int?
	open var spoilerType: String?
	open var sunRoofInstalled: Bool?
	open var thirdRowSeats: String?
	open var timeStamp: Date?
	open var trimBadging: String?
	open var wheelType: String?

	enum CodingKeys: String, CodingKey {
		
		case carSpecialType		 = "car_special_type"
		case carType				 = "car_type"
		case euVehicle			 = "eu_vehicle"
		case exteriorColor		 = "exterior_color"
		case hasLudicoursMode	 = "has_ludicrous_mode"
		case motorizedChargePort  = "motorized_charge_port"
		case perfConfig			 = "perf_config"
		case plg				= "plg"
		case rearSeatHeaters		 = "rear_seat_heaters"
		case rearSeatType		 = "rear_seat_type"
		case rhd					 = "rhd"
		case roofColor			 = "roof_color"
		case seatType			 = "seat_type"
		case spoilerType			 = "spoiler_type"
		case sunRoofInstalled	 = "sun_roof_installed"
		case thirdRowSeats		 = "third_row_seats"
		case timeStamp			= "timestamp"//, TeslaTimeStampTransform())
		case trimBadging			 = "trim_badging"
		case wheelType			 = "wheel_type"
	}
	
}
