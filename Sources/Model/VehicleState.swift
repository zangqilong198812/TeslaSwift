//
//  VehicleState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 20/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class VehicleState: Mappable {
	
	public var driverDoorOpen: Bool?
	public var driverRearDoorOpen: Bool?
	public var passangerDoorOpen: Bool?
	public var passangerRearDoorOpen: Bool?
	public var frontTrunkOpen: Bool?
	public var rearTrunkOpen: Bool?
	public var firmwareVersion: String?
	public var locked: Bool?
	public var sunRoofInstalled: Bool?
	public var sunRoofState: String?
	public var sunRoofPercentageOpen: Int? // null if not installed
	public var darkRims: Bool?
	public var wheelType: String?
	public var hasSpoiler: Bool?
	public var roofColor: String? // "None" for panoramic roof
	public var perfConfig: String?
	
	
	// MARK: Mappable protocol
	required public init?(_ map: Map) {
		
	}
	
	public func mapping(map: Map) {
		driverDoorOpen			<- map["df"]
		driverRearDoorOpen		<- map["dr"]
		passangerDoorOpen		<- map["pf"]
		passangerRearDoorOpen	<- map["pr"]
		frontTrunkOpen			<- map["ft"]
		rearTrunkOpen			<- map["rt"]
		firmwareVersion			<- map["car_verson"]
		locked					<- map["locked"]
		sunRoofInstalled		<- map["sun_roof_installed"]
		sunRoofState			<- map["sun_roof_state"]
		sunRoofPercentageOpen	<- map["sun_roof_percent_open"]
		darkRims				<- map["dark_rims"]
		wheelType				<- map["wheel_type"]
		hasSpoiler				<- map["has_spoiler"]
		roofColor				<- map["roof_color"]
		perfConfig				<- map["perf_config"]
	}
}
