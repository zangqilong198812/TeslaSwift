//
//  ClimateState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

open class ClimateState: Mappable {
	
	public struct Temperature {
		fileprivate var value: Double
		
		public init(celsius: Double?) {
			value = celsius ?? 0.0
		}
		public init(fahrenheit: Double) {
			value = (fahrenheit - 32.0) / 1.8
		}
		
		public var celsius: Double { return value }
		public var fahrenheit: Double { return (value * 1.8) + 32.0 }
	}
	
	open var insideTemperature: Temperature?
	open var outsideTemperature: Temperature?
	open var driverTemperatureSetting: Temperature?
	open var passengerTemperatureSetting: Temperature?
    open var isClimateOn: Bool?
	open var isAutoConditioningOn: Bool?
	open var isFrontDefrosterOn: Bool?
	open var isRearDefrosterOn: Bool?
	/*
	* Fan speed 0-6 or nil
	*/
	open var fanStatus: Int?
    
    open var seatHeaterLeft: Int?
    open var seatHeaterRight: Int?
    open var seatHeaterRearLeft: Int?
    open var seatHeaterRearCenter: Int?
    open var seatHeaterRearRight: Int?
    open var seatHeaterRearLeftBack: Int?
    open var seatHeaterRearRightBack: Int?
	
	
	public required init?(map: Map) { }
	
	open func mapping(map: Map) {
		
		let distanceTransform = TransformOf<Temperature, Double>(
			fromJSON: {
				if let temp = $0 {
					return Temperature(celsius: temp)
				} else {
					return nil
				}
			},
			toJSON: {$0?.celsius}
		)
		
		insideTemperature			<- (map["inside_temp"], distanceTransform)
		outsideTemperature			<- (map["outside_temp"], distanceTransform)
		driverTemperatureSetting	<- (map["driver_temp_setting"], distanceTransform)
		passengerTemperatureSetting <- (map["passenger_temp_setting"], distanceTransform)
        isClimateOn                 <- map["is_climate_on"]
		isAutoConditioningOn		<- map["is_auto_conditioning_on"]
		isFrontDefrosterOn			<- map["is_front_defroster_on"]
		isRearDefrosterOn			<- map["is_rear_defroster_on"]
		fanStatus					<- map["fan_status"]
        
        seatHeaterLeft				<- map["seat_heater_left"]
        seatHeaterRight				<- map["seat_heater_right"]
        seatHeaterRearLeft			<- map["seat_heater_rear_left"]
        seatHeaterRearCenter		<- map["seat_heater_rear_center"]
        seatHeaterRearRight			<- map["seat_heater_rear_right"]
        seatHeaterRearLeftBack		<- map["seat_heater_rear_left_back"]
        seatHeaterRearRightBack		<- map["seat_heater_rear_right_back"]
	}
}
