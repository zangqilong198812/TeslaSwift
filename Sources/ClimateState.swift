//
//  ClimateState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class ClimateState: Codable {
	
	public struct Temperature: Codable {
		fileprivate var value: Double
		
		public init(celsius: Double?) {
			value = celsius ?? 0.0
		}
		public init(fahrenheit: Double) {
			value = (fahrenheit - 32.0) / 1.8
		}
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			if let tempValue = try container.decode(Double?.self) {
				value = tempValue
			} else {
				value = 0.0
			}
		}
		
		public func encode(to encoder: Encoder) throws {
			
			var container = encoder.singleValueContainer()
			try container.encode(value)
			
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
	
	open var timeStamp: TimeInterval?
	
	enum CodingKeys: String, CodingKey {
		/*
		let temperatureTransform = TransformOf<Temperature, Double>(
			fromJSON: {
				if let temp = $0 {
					return Temperature(celsius: temp)
				} else {
					return nil
				}
			},
			toJSON: {$0?.celsius}
		)*/
		
		case driverTemperatureSetting	= "driver_temp_setting"//, temperatureTransform)
		case fanStatus					 = "fan_status"
		
		case insideTemperature			= "inside_temp"//, temperatureTransform)
		
		case isAutoConditioningOn		 = "is_auto_conditioning_on"
		case isClimateOn                  = "is_climate_on"
		case isFrontDefrosterOn			 = "is_front_defroster_on"
		case isRearDefrosterOn			 = "is_rear_defroster_on"
		
		case leftTemperatureDirection	 = "left_temp_direction"
		
		case maxAvailableTemperature     = "max_avail_temp"//, temperatureTransform)
		case minAvailableTemperature     = "min_avail_temp"//, temperatureTransform)
		
		case outsideTemperature			= "outside_temp"//, temperatureTransform)
		
		case passengerTemperatureSetting = "passenger_temp_setting"//, temperatureTransform)
		
		case rightTemperatureDirection	 = "right_temp_direction"
		
		
        case seatHeaterLeft				 = "seat_heater_left"
		case seatHeaterRearCenter		 = "seat_heater_rear_center"
		case seatHeaterRearLeft			 = "seat_heater_rear_left"
		case seatHeaterRearLeftBack		 = "seat_heater_rear_left_back"
		case seatHeaterRearRight			 = "seat_heater_rear_right"
		case seatHeaterRearRightBack		 = "seat_heater_rear_right_back"
		case seatHeaterRight				 = "seat_heater_right"
		
		
        case smartPreconditioning		 = "smart_preconditioning"
		
		case timeStamp					= "timestamp"//, TeslaTimeStampTransform())
        
	}
}
