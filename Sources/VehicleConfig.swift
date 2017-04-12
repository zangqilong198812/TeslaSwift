//
//  VehicleConfig.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/03/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

open class VehicleConfig: Mappable {
	
	open var carSpecialType: String?
	open var carType: String?
	open var euVehicle: Bool?
	open var exteriorColor: String?
	open var hasLudicoursMode: Bool?
	open var motorizedChargePort: Bool?
	open var perfConfig: String?
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

	required public init?(map: Map) {
		
	}
	
	open func mapping(map: Map) {
		
		carSpecialType		<- map["car_special_type"]
		carType				<- map["car_type"]
		euVehicle			<- map["eu_vehicle"]
		exteriorColor		<- map["exterior_color"]
		hasLudicoursMode	<- map["has_ludicrous_mode"]
		motorizedChargePort <- map["motorized_charge_port"]
		perfConfig			<- map["perf_config"]
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
	}
	
}
