//
//  Vehicle.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class Vehicle: Mappable {
	
	public var color:String?
	public var displayName:String?
	public var id:Int?
	public var optionCodes:String?
	public var userID:Int?
	public var vehicleID:Int?
	public var vin:String?
	public var tokens:[String]?
	public var state:String?
	
	//MARK: Mappable protocol
	required public init?(_ map: Map){
		
	}
	
	public func mapping(map: Map) {
		color		<- map["color"]
		displayName	<- map["display_name"]
		id			<- map["id"]
		optionCodes	<- map["option_codes"]
		userID		<- map["user_id"]
		vehicleID	<- map["vehicle_id"]
		vin			<- map["vin"]
		tokens		<- map["tokens"]
		state		<- map["state"]
	}
}