//
//  ClimateState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class ClimateState: Mappable {
	
	struct Temperature {
		private var value:Double
		
		init(celsius:Double?) {
			value = celsius ?? 0.0
		}
		init(fahrenheit:Double) {
			value = (fahrenheit - 32.0) / 1.8
		}
		
		var celsius:Double { return value }
		var fahrenheit:Double { return (value * 1.8) + 32.0 }
	}
	
	var insideTemperature:Temperature?
	var outsideTemperature:Temperature?
	var driverTemperatureSetting:Temperature?
	var passengerTemperatureSetting:Temperature?
	var isAutoConditioningOn:Bool?
	var isFrontDefrosterOn:Bool?
	var isRearDefrosterOn:Bool?
	/*
	* Fan speed 0-6 or nil
	*/
	var fanStatus:Int?
	
	
	public required init?(_ map: Map) { }
	
	public func mapping(map: Map) {
		
		let distanceTransform = TransformOf<Temperature, Double>(fromJSON: { Temperature(celsius: $0!) }, toJSON: {$0?.celsius})
		
		insideTemperature			<- (map["inside_temp"],distanceTransform)
		outsideTemperature			<- (map["outside_temp"],distanceTransform)
		driverTemperatureSetting	<- (map["driver_temp_setting"],distanceTransform)
		passengerTemperatureSetting <- (map["passenger_temp_setting"],distanceTransform)
		isAutoConditioningOn		<- map["is_auto_conditioning_on"]
		isFrontDefrosterOn			<- map["is_front_defroster_on"]
		isRearDefrosterOn			<- map["is_rear_defroster_on"]
		fanStatus					<- map["fan_status"]
	}
}