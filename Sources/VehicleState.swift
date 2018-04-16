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
	
	open var firmwareVersion: String?
	
	private var centerDisplayStateBool: Int?
	open var centerDisplayState: Bool? { return centerDisplayStateBool == 1 }
	
	private var driverDoorOpenBool: Int?
	open var driverDoorOpen: Bool? { return driverDoorOpenBool == 1 }
	private var driverRearDoorOpenBool: Int?
	open var driverRearDoorOpen: Bool? { return driverRearDoorOpenBool == 1 }
	
	private var frontTrunkOpenBool: Int?
	open var frontTrunkOpen: Bool? { return frontTrunkOpenBool == 1 }
	
	open var homelinkNearby: Bool?
	
	open var lastAutoparkError: String?
	
	open var locked: Bool?
	
	open var notificationsSupported: Bool?
	
	open var odometer: Double?
	
	open var parsedCalendarSupported: Bool?
	
	private var passengerDoorOpenBool: Int?
	open var passengerDoorOpen: Bool? { return passengerDoorOpenBool == 1 }
	private var passengerRearDoorOpenBool: Int?
	open var passengerRearDoorOpen: Bool? { return passengerRearDoorOpenBool == 1 }
	
	open var remoteStart: Bool?
	open var remoteStartSupported: Bool?
	
	private var rearTrunkOpenBool: Int?
	open var rearTrunkOpen: Bool? { return rearTrunkOpenBool == 1 }
	
	open var sunRoofPercentageOpen: Int? // null if not installed
	open var sunRoofState: String?
	
	open var timeStamp: TimeInterval?
	
	open var valetMode: Bool?
	open var valetPinNeeded: Bool?
	
	open var vehicleName: String?
	
	// MARK: Codable protocol
	
	enum CodingKeys: String, CodingKey {
		case apiVersion				 = "api_version"
		
		case autoparkState			 = "autopark_state"
		case autoparkStateV2		 = "autopark_state_v2"
		case autoparkStyle			 = "autopark_style"
		
		case calendarSupported		 = "calendar_supported"
		
		case firmwareVersion		 = "car_version"
		
		case centerDisplayStateBool		 = "center_display_state"
		
		case driverDoorOpenBool			 = "df"
		case driverRearDoorOpenBool		 = "dr"
		case frontTrunkOpenBool			 = "ft"
		
		case homelinkNearby			 = "homelink_nearby"
		
		case lastAutoparkError		 = "last_autopark_error"
		
		case locked					 = "locked"
		
		case notificationsSupported	 = "notifications_supported"
		
		case odometer				 = "odometer"
		
		case parsedCalendarSupported = "parsed_calendar_supported"
		
		case passengerDoorOpenBool		 = "pf"
		case passengerRearDoorOpenBool	 = "pr"
		
		case remoteStart			 = "remote_start"
		case remoteStartSupported	 = "remote_start_supported"
		
		case rearTrunkOpenBool			 = "rt"
		
		case sunRoofPercentageOpen	 = "sun_roof_percent_open"
		case sunRoofState			 = "sun_roof_state"
		
		case timeStamp				= "timestamp"//, TeslaTimeStampTransform())
		
		case valetMode				 = "valet_mode"
		case valetPinNeeded			 = "valet_pin_needed"
		
		case vehicleName			 = "vehicle_name"
	}
}
