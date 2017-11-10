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
		
<<<<<<< HEAD
		case carSpecialType		 = "car_special_type"
		case carType				 = "car_type"
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
		case timeStamp			= "timestamp"//, TeslaTimeStampTransform())
		case trimBadging			 = "trim_badging"
		case wheelType			 = "wheel_type"
=======
	}
	
	open func mapping(map: Map) {
		
		carSpecialType		<- map["car_special_type"]
		carType				<- map["car_type"]
		euVehicle			<- map["eu_vehicle"]
		exteriorColor		<- map["exterior_color"]
		hasLudicoursMode	<- map["has_ludicrous_mode"]
		motorizedChargePort <- map["motorized_charge_port"]
		perfConfig			<- map["perf_config"]
		plg					<- map["plg"]
		rearSeatHeaters		<- map["rear_seat_heaters"]
		rearSeatType		<- map["rear_seat_type"]
		rhd					<- map["rhd"]
		roofColor			<- map["roof_color"]
		seatType			<- map["seat_type"]
		spoilerType			<- map["spoiler_type"]
		sunRoofInstalled	<- map["sun_roof_installed"]
		thirdRowSeats		<- map["third_row_seats"]
		timeStamp			<- (map["timestamp"], TeslaTimeStampTransform())
		trimBadging			<- map["trim_badging"]
		wheelType			<- map["wheel_type"]
>>>>>>> master
	}
	
}
