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
	
	private var calendarSupportedBool: Int?
	open var calendarSupported: Bool? { return calendarSupportedBool == 1 }
	
	open var carType: String?
	open var firmwareVersion: String?
	
	open var centerDisplayState: Bool? {
		guard let centerDisplayStateInt = centerDisplayStateInt else { return nil }
		return centerDisplayStateInt > 0
	}
	private var centerDisplayStateInt: Int?
	
	private var darkRimsBool: Int?
	open var darkRims: Bool? { return darkRimsBool == 1 }
	
	private var driverDoorOpenBool: Int?
	open var driverDoorOpen: Bool? { return driverDoorOpenBool == 1 }
	private var driverRearDoorOpenBool: Int?
	open var driverRearDoorOpen: Bool? { return driverRearDoorOpenBool == 1 }
	
	open var exteriorColor: String?
	
	private var frontTrunkOpenBool: Int?
	open var frontTrunkOpen: Bool? { return frontTrunkOpenBool == 1 }
	
	private var hasSpoilerBool: Int?
	open var hasSpoiler: Bool? { return hasSpoilerBool == 1 }
	
	private var homelinkNearbyBool: Int?
	open var homelinkNearby: Bool? { return homelinkNearbyBool == 1 }
	
	open var lastAutoparkError: String?
	
	private var lockedBool: Int?
	open var locked: Bool? { return lockedBool == 1 }
	
	private var notificationsSupportedBool: Int?
	open var notificationsSupported: Bool? { return notificationsSupportedBool == 1 }
	
	open var odometer: Double?
	
	private var parsedCalendarSupportedBool: Int?
	open var parsedCalendarSupported: Bool? { return parsedCalendarSupportedBool == 1 }
	open var perfConfig: String?
	
	private var passengerDoorOpenBool: Int?
	open var passengerDoorOpen: Bool? { return passengerDoorOpenBool == 1 }
	private var passengerRearDoorOpenBool: Int?
	open var passengerRearDoorOpen: Bool? { return passengerRearDoorOpenBool == 1 }
	
	private var rearSeatHeatersBool: Int?
	open var rearSeatHeaters: Bool? { return rearSeatHeatersBool == 1 }
	open var rearSeatType: Int?
	
	private var remoteStartBool: Int?
	open var remoteStart: Bool? { return remoteStartBool == 1 }
	private var remoteStartSupportedBool: Int?
	open var remoteStartSupported: Bool? { return remoteStartSupportedBool == 1 }
	
	private var rhdBool: Int?
	open var rhd: Bool? { return rhdBool == 1 }
	
	open var roofColor: String? // "None" for panoramic roof
	
	private var rearTrunkOpenBool: Int?
	open var rearTrunkOpen: Bool? { return rearTrunkOpenBool == 1 }
	
	open var seatType: Int?
	
	open var spoilerType: String?
	
	open var sunRoofInstalled: Int?
	open var sunRoofPercentageOpen: Int? // null if not installed
	open var sunRoofState: String?
	
	open var thirdRowSeats: String?
	
	open var timeStamp: TimeInterval?
	
	private var valetModeBool: Int?
	open var valetMode: Bool? { return valetModeBool == 1 }
	private var valetPinNeededBool: Int?
	open var valetPinNeeded: Bool? { return valetPinNeededBool == 1 }
	
	open var vehicleName: String?
	
	open var wheelType: String?
	
	// MARK: Codable protocol
	
	enum CodingKeys: String, CodingKey {
		case apiVersion				 = "api_version"
		
		case autoparkState			 = "autopark_state"
		case autoparkStateV2			 = "autopark_state_v2"
		case autoparkStyle			 = "autopark_style"
		
		case calendarSupportedBool		 = "calendar_supported"
		
		case carType					 = "car_type"
		case firmwareVersion			 = "car_version"
		
		case centerDisplayStateInt		 = "center_display_state"
		
		case darkRimsBool				 = "dark_rims"
		
		case driverDoorOpenBool			 = "df"
		case driverRearDoorOpenBool		 = "dr"
		
		case exteriorColor			 = "exterior_color"
		
		case frontTrunkOpenBool			 = "ft"
		
		case hasSpoilerBool				 = "has_spoiler"
		
		case homelinkNearbyBool			 = "homelink_nearby"
		
		case lastAutoparkError		 = "last_autopark_error"
		
		case lockedBool					 = "locked"
		
		case notificationsSupportedBool	 = "notifications_supported"
		
		case odometer				 = "odometer"
		
		case parsedCalendarSupportedBool	 = "parsed_calendar_supported"
		case perfConfig				 = "perf_config"
		
		case passengerDoorOpenBool		 = "pf"
		case passengerRearDoorOpenBool	 = "pr"
		
		case rearSeatHeatersBool			 = "rear_seat_heaters"
		case rearSeatType			 = "rear_seat_type"
		
		case remoteStartBool				 = "remote_start"
		case remoteStartSupportedBool	 = "remote_start_supported"
		
		case rhdBool						 = "rhd"
		case roofColor				 = "roof_color"
		
		case rearTrunkOpenBool			 = "rt"
		
		case seatType				 = "seat_type"
		
		case spoilerType				 = "spoiler_type"
		
		case sunRoofInstalled		 = "sun_roof_installed"
		case sunRoofPercentageOpen	 = "sun_roof_percent_open"
		case sunRoofState			 = "sun_roof_state"
		
		case thirdRowSeats			 = "third_row_seats"
		
		case timeStamp				= "timestamp"//, TeslaTimeStampTransform())
		
		case valetModeBool				 = "valet_mode"
		case valetPinNeededBool			 = "valet_pin_needed"
		
		case vehicleName				 = "vehicle_name"
		
		case wheelType				 = "wheel_type"
		
	}
}
