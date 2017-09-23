//
//  Vehicle.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class Vehicle: Codable {
	
	open var backseatToken: String?
	open var backseatTokenUpdatedAt: Date?
	open var calendarEnabled: Bool?
	open var color: String?
	open var displayName: String?
	open var id: String? {
		get {
			guard let value = idInt else { return nil }
			return "\(value)"
		}
		set {
			guard let newValue = newValue else { idInt = nil; return }
			idInt = Int(newValue)
		}
	}
	open var idInt: Int?
	open var idS: String?
	open var inService: Bool?
	open var notificationsEnabled: Bool?
	open var optionCodes: String?
	open var remoteStartEnabled: Bool?
	open var state: String?
	open var tokens: [String]?
	open var vehicleID: Int?
	open var vin: String?
	
	// MARK: Codable protocol
	
	private enum CodingKeys: String, CodingKey {
	/*	let idTransform = TransformOf<String, Int>(fromJSON: {
			if let value = $0 {
				return "\(value)"
			} else {
				return nil
			}
		}, toJSON: {
			if let value = $0 {
				return Int(value)
			} else {
				return nil
			}
		})*/
		
		case backseatToken			 = "backseat_token"
		case backseatTokenUpdatedAt	 = "backseat_token_updated_at"
		case calendarEnabled			 = "calendar_enabled"
		case color					 = "color"
		case displayName				 = "display_name"
		case idInt						= "id"//, idTransform)
		case idS						 = "id_s"
		case inService				 = "in_service"
		case notificationsEnabled	 = "notifications_enabled"
		case optionCodes				 = "option_codes"
		case remoteStartEnabled		 = "remote_start_enabled"
		case state					 = "state"
		case tokens					 = "tokens"
		case vehicleID				 = "vehicle_id"
		case vin						 = "vin"

	}
	
	required public init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		backseatToken = try container.decode(String?.self, forKey: .backseatToken)
		backseatTokenUpdatedAt = try container.decode(Date?.self, forKey: .backseatTokenUpdatedAt)
		calendarEnabled = try container.decode(Bool?.self, forKey: .calendarEnabled)
		color = try container.decode(String?.self, forKey: .color)
		displayName = try container.decode(String?.self, forKey: .displayName)
		idInt = try container.decode(Int?.self, forKey: .idInt)
		idS = try container.decode(String?.self, forKey: .idS)
		inService = try container.decode(Bool?.self, forKey: .inService)
		notificationsEnabled = try container.decode(Bool?.self, forKey: .notificationsEnabled)
		optionCodes = try container.decode(String?.self, forKey: .optionCodes)
		remoteStartEnabled = try container.decode(Bool?.self, forKey: .remoteStartEnabled)
		state = try container.decode(String?.self, forKey: .state)
		tokens = try container.decode([String]?.self, forKey: .tokens)
		vehicleID = try container.decode(Int?.self, forKey: .vehicleID)
		vin = try container.decode(String?.self, forKey: .vin)
	}
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(backseatTokenUpdatedAt, forKey: .backseatTokenUpdatedAt)
		try container.encode(calendarEnabled, forKey: .calendarEnabled)
		try container.encode(color, forKey: .color)
		try container.encode(displayName, forKey: .displayName)
		try container.encode(idInt, forKey: .idInt)
		try container.encode(idS, forKey: .idS)
		try container.encode(inService, forKey: .inService)
		try container.encode(notificationsEnabled, forKey: .notificationsEnabled)
		try container.encode(optionCodes, forKey: .optionCodes)
		try container.encode(remoteStartEnabled, forKey: .remoteStartEnabled)
		try container.encode(state, forKey: .state)
		try container.encode(tokens, forKey: .tokens)
		try container.encode(vehicleID, forKey: .vehicleID)
		try container.encode(vin, forKey: .vin)
		
	}

}
