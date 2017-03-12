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
	
	open var driverTemperatureSetting: Temperature?
	/*
	* Fan speed 0-6 or nil
	*/
	open var fanStatus: Int?
	
	open var insideTemperature: Temperature?
	
	open var isAutoConditioningOn: Bool?
	open var isClimateOn: Bool?
	open var isFrontDefrosterOn: Bool?
	open var isRearDefrosterOn: Bool?
	
	open var leftTemperatureDirection: Int?
	
	open var maxAvailableTemperature: Temperature?
	open var minAvailableTemperature: Temperature?
	
	open var outsideTemperature: Temperature?
	
	open var passengerTemperatureSetting: Temperature?
	
	/*
	* Temp directions 0 at least 583...
	*/
	open var rightTemperatureDirection: Int?
	
	
    open var seatHeaterLeft: Int?
	open var seatHeaterRearCenter: Int?
	open var seatHeaterRearLeft: Int?
	open var seatHeaterRearLeftBack: Int?
	open var seatHeaterRearRight: Int?
	open var seatHeaterRearRightBack: Int?
	open var seatHeaterRight: Int?
	
	open var smartPreconditioning: Int?
	
	open var timeStamp: Date?
	
	public required init?(map: Map) { }
	
	open func mapping(map: Map) {
		
		let temperatureTransform = TransformOf<Temperature, Double>(
			fromJSON: {
				if let temp = $0 {
					return Temperature(celsius: temp)
				} else {
					return nil
				}
			},
			toJSON: {$0?.celsius}
		)
		
		driverTemperatureSetting	<- (map["driver_temp_setting"], temperatureTransform)
		fanStatus					<- map["fan_status"]
		
		insideTemperature			<- (map["inside_temp"], temperatureTransform)
		
		isAutoConditioningOn		<- map["is_auto_conditioning_on"]
		isClimateOn                 <- map["is_climate_on"]
		isFrontDefrosterOn			<- map["is_front_defroster_on"]
		isRearDefrosterOn			<- map["is_rear_defroster_on"]
		
		leftTemperatureDirection	<- map["left_temp_direction"]
		
		maxAvailableTemperature     <- (map["max_avail_temp"], temperatureTransform)
		minAvailableTemperature     <- (map["min_avail_temp"], temperatureTransform)
		
		outsideTemperature			<- (map["outside_temp"], temperatureTransform)
		
		passengerTemperatureSetting <- (map["passenger_temp_setting"], temperatureTransform)
		
		rightTemperatureDirection	<- map["right_temp_direction"]
		
		
        seatHeaterLeft				<- map["seat_heater_left"]
		seatHeaterRearCenter		<- map["seat_heater_rear_center"]
		seatHeaterRearLeft			<- map["seat_heater_rear_left"]
		seatHeaterRearLeftBack		<- map["seat_heater_rear_left_back"]
		seatHeaterRearRight			<- map["seat_heater_rear_right"]
		seatHeaterRearRightBack		<- map["seat_heater_rear_right_back"]
		seatHeaterRight				<- map["seat_heater_right"]
		
		
        smartPreconditioning		<- map["smart_preconditioning"]
		
		timeStamp					<- (map["timestamp"], TeslaTimeStampTransform())
        
	}
}
