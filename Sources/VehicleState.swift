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
	
	open var firmwareVersion: String?
	
	private var centerDisplayStateBool: Int?
	open var centerDisplayState: Bool? { return centerDisplayStateBool == 1 }
	
	private var driverDoorOpenBool: Int?
	open var driverDoorOpen: Bool? { return driverDoorOpenBool == 1 }
	private var driverRearDoorOpenBool: Int?
	open var driverRearDoorOpen: Bool? { return driverRearDoorOpenBool == 1 }
	
	private var frontTrunkOpenBool: Int?
	open var frontTrunkOpen: Bool? { return frontTrunkOpenBool == 1 }
	
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
	
	private var passengerDoorOpenBool: Int?
	open var passengerDoorOpen: Bool? { return passengerDoorOpenBool == 1 }
	private var passengerRearDoorOpenBool: Int?
	open var passengerRearDoorOpen: Bool? { return passengerRearDoorOpenBool == 1 }
	
	private var remoteStartBool: Int?
	open var remoteStart: Bool? { return remoteStartBool == 1 }
	private var remoteStartSupportedBool: Int?
	open var remoteStartSupported: Bool? { return remoteStartSupportedBool == 1 }
	
	private var rearTrunkOpenBool: Int?
	open var rearTrunkOpen: Bool? { return rearTrunkOpenBool == 1 }
	
	open var sunRoofPercentageOpen: Int? // null if not installed
	open var sunRoofState: String?
	
	open var timeStamp: TimeInterval?
	
	private var valetModeBool: Int?
	open var valetMode: Bool? { return valetModeBool == 1 }
	private var valetPinNeededBool: Int?
	open var valetPinNeeded: Bool? { return valetPinNeededBool == 1 }
	
	open var vehicleName: String?
	
	// MARK: Codable protocol
	
	enum CodingKeys: String, CodingKey {
		case apiVersion				 = "api_version"
		
		case autoparkState			 = "autopark_state"
		case autoparkStateV2			 = "autopark_state_v2"
		case autoparkStyle			 = "autopark_style"
		
		case calendarSupportedBool		 = "calendar_supported"
		
		case firmwareVersion			 = "car_version"
		
		case centerDisplayStateBool		 = "center_display_state"
		
		case driverDoorOpenBool			 = "df"
		case driverRearDoorOpenBool		 = "dr"
		case frontTrunkOpenBool			 = "ft"
		
		case homelinkNearbyBool			 = "homelink_nearby"
		
		case lastAutoparkError		 = "last_autopark_error"
		
		case lockedBool					 = "locked"
		
		case notificationsSupportedBool	 = "notifications_supported"
		
		case odometer				 = "odometer"
		
		case parsedCalendarSupportedBool	 = "parsed_calendar_supported"
		
		case passengerDoorOpenBool		 = "pf"
		case passengerRearDoorOpenBool	 = "pr"
		
		case remoteStartBool				 = "remote_start"
		case remoteStartSupportedBool	 = "remote_start_supported"
		
		case rearTrunkOpenBool			 = "rt"
		
		case sunRoofPercentageOpen	 = "sun_roof_percent_open"
		case sunRoofState			 = "sun_roof_state"
		
		case timeStamp				= "timestamp"//, TeslaTimeStampTransform())
		
		case valetModeBool				 = "valet_mode"
		case valetPinNeededBool			 = "valet_pin_needed"
		
		case vehicleName				 = "vehicle_name"
	}
}
