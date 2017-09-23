//
//  VehicleState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 20/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class VehicleState: Codable {
	
	open var apiVersion: Int?
	
	open var autoparkState: String?
	open var autoparkStateV2: String?
	open var autoparkStyle: String?
	
	open var calendarSupported: Bool?
	
	open var carType: String?
	open var firmwareVersion: String?
	
	open var centerDisplayState: Bool? {
		guard let centerDisplayStateInt = centerDisplayStateInt else { return nil }
		return centerDisplayStateInt > 0
	}
	private var centerDisplayStateInt: Int?
	
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
	
	open var timeStamp: Date?
	
	open var valetMode: Bool?
	open var valetPinNeeded: Bool?
	
	open var vehicleName: String?
	
	open var wheelType: String?
	
	// MARK: Codable protocol
	
	enum CodingKeys: String, CodingKey {
		case apiVersion				 = "api_version"
		
		case autoparkState			 = "autopark_state"
		case autoparkStateV2			 = "autopark_state_v2"
		case autoparkStyle			 = "autopark_style"
		
		case calendarSupported		 = "calendar_supported"
		
		case carType					 = "car_type"
		case firmwareVersion			 = "car_version"
		
		case centerDisplayStateInt		 = "center_display_state"
		
		case darkRims				 = "dark_rims"
		
		case driverDoorOpen			 = "df"
		case driverRearDoorOpen		 = "dr"
		
		case exteriorColor			 = "exterior_color"
		
		case frontTrunkOpen			 = "ft"
		
		case hasSpoiler				 = "has_spoiler"
		
		case homelinkNearby			 = "homelink_nearby"
		
		case lastAutoparkError		 = "last_autopark_error"
		
		case locked					 = "locked"
		
		case notificationsSupported	 = "notifications_supported"
		
		case odometer				 = "odometer"
		
		case parsedCalendarSupported	 = "parsed_calendar_supported"
		case perfConfig				 = "perf_config"
		
		case passengerDoorOpen		 = "pf"
		case passengerRearDoorOpen	 = "pr"
		
		case rearSeatHeaters			 = "rear_seat_heaters"
		case rearSeatType			 = "rear_seat_type"
		
		case remoteStart				 = "remote_start"
		case remoteStartSupported	 = "remote_start_supported"
		
		case rhd						 = "rhd"
		case roofColor				 = "roof_color"
		
		case rearTrunkOpen			 = "rt"
		
		case seatType				 = "seat_type"
		
		case spoilerType				 = "spoiler_type"
		
		case sunRoofInstalled		 = "sun_roof_installed"
		case sunRoofPercentageOpen	 = "sun_roof_percent_open"
		case sunRoofState			 = "sun_roof_state"
		
		case thirdRowSeats			 = "third_row_seats"
		
		case timeStamp				= "timestamp"//, TeslaTimeStampTransform())
		
		case valetMode				 = "valet_mode"
		case valetPinNeeded			 = "valet_pin_needed"
		
		case vehicleName				 = "vehicle_name"
		
		case wheelType				 = "wheel_type"
		
	}
}
