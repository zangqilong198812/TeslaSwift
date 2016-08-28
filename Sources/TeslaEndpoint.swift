//
//  TeslaEndpoint.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 16/04/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

enum Endpoint {
	
	case Authentication
	case Vehicles
	case MobileAccess(vehicleID: Int)
	case ChargeState(vehicleID: Int)
	case ClimateState(vehicleID: Int)
	case DriveState(vehicleID: Int)
	case GuiSettings(vehicleID: Int)
	case VehicleState(vehicleID: Int)
	case Command(vehicleID: Int, command:VehicleCommand)
}

extension Endpoint {
	
	var path: String {
		switch self {
		case .Authentication:
			return "/oauth/token"
		case .Vehicles:
			return "/api/1/vehicles"
		case .MobileAccess(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/mobile_enabled"
		case .ChargeState(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/charge_state"
		case .ClimateState(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/climate_state"
		case .DriveState(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/drive_state"
		case .GuiSettings(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/gui_settings"
		case .VehicleState(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/vehicle_state"
		case let .Command(vehicleID, command):
			return "/api/1/vehicles/\(vehicleID)/\(command.path())"
		}
	}
	
	var method: String {
		switch self {
		case .Authentication, .Command:
			return "POST"
		case .Vehicles, MobileAccess, ChargeState, ClimateState, DriveState, .GuiSettings, .VehicleState:
			return "GET"
		}
	}
	
	func baseURL(useMockServer: Bool) -> String {
		if useMockServer {
			return "https://private-623898-modelsapi.apiary-mock.com"
		} else {
			return "https://owner-api.teslamotors.com"
		}
	}
}
