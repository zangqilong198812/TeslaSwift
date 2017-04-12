//
//  Vehicle.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

open class Vehicle: Mappable {
	
	open var backseatToken: String?
	open var backseatTokenUpdatedAt: Date?
	open var calendarEnabled: Bool?
	open var color: String?
	open var displayName: String?
	open var id: Int?
	open var idS: String?
	open var inService: Bool?
	open var notificationsEnabled: Bool?
	open var optionCodes: String?
	open var remoteStartEnabled: Bool?
	open var state: String?
	open var tokens: [String]?
	open var vehicleID: Int?
	open var vin: String?
	
	// MARK: Mappable protocol
	required public init?(map: Map) {
		
	}
	
	open func mapping(map: Map) {
		backseatToken			<- map["backseat_token"]
		backseatTokenUpdatedAt	<- map["backseat_token_updated_at"]
		calendarEnabled			<- map["calendar_enabled"]
		color					<- map["color"]
		displayName				<- map["display_name"]
		id						<- map["id"]
		idS						<- map["id_s"]
		inService				<- map["in_service"]
		notificationsEnabled	<- map["notifications_enabled"]
		optionCodes				<- map["option_codes"]
		remoteStartEnabled		<- map["remote_start_enabled"]
		state					<- map["state"]
		tokens					<- map["tokens"]
		vehicleID				<- map["vehicle_id"]
		vin						<- map["vin"]

	}
}
