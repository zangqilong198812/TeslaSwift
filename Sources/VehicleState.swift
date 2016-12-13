//
//  VehicleState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 20/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

open class VehicleState: Mappable {
	
	open var apiVersion: Int?
	
	open var autoparkState: String?
	open var autoparkStateV2: String?
	open var autoparkStyle: String?
	
	open var calendarSupported: Bool?
	
	open var carType: String?
	open var firmwareVersion: String?
	
	open var centerDisplayState: Bool?
	
	open var darkRims: Bool?
	
	open var driverDoorOpen: Bool?
	open var driverRearDoorOpen: Bool?
	
	open var exteriorColor: String?
	
	open var frontTrunkOpen: Bool?
	
	open var hasSpoiler: Bool?
	
	open var homelinkNearby: Bool?
	
	open var lastAutoparkError: String?
	
	open var locked: Bool?
	
	open var notificationsSupported: Bool?
	
	open var odometer: Double?
	
	open var parsedCalendarSupported: Bool?
	open var perfConfig: String?
	
	open var passengerDoorOpen: Bool?
	open var passengerRearDoorOpen: Bool?
	
	open var rearSeatHeaters: Bool?
	open var rearSeatType: Int?
	
	open var remoteStart: Bool?
	open var remoteStartSupported: Bool?
	
	open var rhd: Bool?
	
	open var roofColor: String? // "None" for panoramic roof
	
	open var rearTrunkOpen: Bool?
	
	open var seatType: Int?
	
	open var spoilerType: String?
	
	open var sunRoofInstalled: Int?
	open var sunRoofPercentageOpen: Int? // null if not installed
	open var sunRoofState: String?
	
	open var thirdRowSeats: String?
	
	open var valetMode: Bool?
	open var valetPinNeeded: Bool?
	
	open var vehicleName: String?
	
	open var wheelType: String?
	
	
	// MARK: Mappable protocol
	required public init?(map: Map) {
		
	}
	
	open func mapping(map: Map) {
		apiVersion				<- map["api_version"]
		
		autoparkState			<- map["autopark_state"]
		autoparkStateV2			<- map["autopark_state_v2"]
		autoparkStyle			<- map["autopark_style"]
		
		calendarSupported		<- map["calendar_supported"]
		
		carType					<- map["car_type"]
		firmwareVersion			<- map["car_version"]
		
		centerDisplayState		<- map["center_display_state"]
		
		darkRims				<- map["dark_rims"]
		
		driverDoorOpen			<- map["df"]
		driverRearDoorOpen		<- map["dr"]
		
		exteriorColor			<- map["exterior_color"]
		
		frontTrunkOpen			<- map["ft"]
		
		hasSpoiler				<- map["has_spoiler"]
		
		homelinkNearby			<- map["homelink_nearby"]
		
		lastAutoparkError		<- map["last_autopark_error"]
		
		locked					<- map["locked"]
		
		notificationsSupported	<- map["notifications_supported"]
		
		odometer				<- map["odometer"]
		
		parsedCalendarSupported	<- map["parsed_calendar_supported"]
		perfConfig				<- map["perf_config"]
		
		passengerDoorOpen		<- map["pf"]
		passengerRearDoorOpen	<- map["pr"]
		
		rearSeatHeaters			<- map["rear_seat_heaters"]
		rearSeatType			<- map["rear_seat_type"]
		
		remoteStart				<- map["remote_start"]
		remoteStartSupported	<- map["remote_start_supported"]
		
		rhd						<- map["rhd"]
		roofColor				<- map["roof_color"]
		
		rearTrunkOpen			<- map["rt"]
		
		seatType				<- map["seat_type"]
		
		spoilerType				<- map["spoiler_type"]
		
		sunRoofInstalled		<- map["sun_roof_installed"]
		sunRoofPercentageOpen	<- map["sun_roof_percent_open"]
		sunRoofState			<- map["sun_roof_state"]
		
		thirdRowSeats			<- map["third_row_seats"]
		
		valetMode				<- map["valet_mode"]
		valetPinNeeded			<- map["valet_pin_needed"]
		
		vehicleName				<- map["vehicle_name"]
		
		wheelType				<- map["wheel_type"]
		
	}
}
