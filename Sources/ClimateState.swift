//
//  ClimateState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class ClimateState: Codable {
	
	private var batteryHeaterBool: Int?
	open var batteryHeater: Bool? { return batteryHeaterBool == 1 }
	
	private var batteryHeaterNoPowerBool: Int?
	open var batteryHeaterNoPower: Bool? { return batteryHeaterNoPowerBool == 1 }
	
	public struct Temperature: Codable {
		fileprivate var value: Measurement<UnitTemperature>
		
		public init(celsius: Double?) {
			let tempValue = celsius ?? 0.0
			value = Measurement<UnitTemperature>(value: tempValue, unit: .celsius)
		}
		public init(fahrenheit: Double) {
			value = Measurement<UnitTemperature>(value: fahrenheit, unit: .fahrenheit)
		}
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			if let tempValue = try container.decode(Double?.self) {
				value = Measurement<UnitTemperature>(value: tempValue, unit: .celsius)
			} else {
				value = Measurement<UnitTemperature>(value: 0, unit: .celsius)
			}
		}
		
		public func encode(to encoder: Encoder) throws {
			
			var container = encoder.singleValueContainer()
			try container.encode(value.converted(to: .celsius).value)
			
		}
		
		public var celsius: Double { return value.converted(to: .celsius).value }
		public var fahrenheit: Double { return value.converted(to: .fahrenheit).value }
	}
	
	open var driverTemperatureSetting: Temperature?
	/*
	* Fan speed 0-6 or nil
	*/
	open var fanStatus: Int?
	
	open var insideTemperature: Temperature?
	
	private var isAutoConditioningOnBool: Int?
	open var isAutoConditioningOn: Bool? { return isAutoConditioningOnBool == 1 }
	private var isClimateOnBool: Int?
	open var isClimateOn: Bool? { return isClimateOnBool == 1 }
	private var isFrontDefrosterOnBool: Int?
	open var isFrontDefrosterOn: Bool? { return isFrontDefrosterOnBool == 1 }
	private var isRearDefrosterOnBool: Int?
	open var isRearDefrosterOn: Bool? { return isRearDefrosterOnBool == 1 }
	
	private var isPreconditioningBool: Int?
	open var isPreconditioning: Bool? { return isPreconditioningBool == 1 }
	
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
	
	open var sideMirrorHeaters: Int?
	open var steeringWheelHeater: Int?
	open var wiperBladeHeater: Int?
	
	open var smartPreconditioning: Int?
	
	open var timeStamp: TimeInterval?
	
	enum CodingKeys: String, CodingKey {
		
		case batteryHeaterBool   = "battery_heater"
		case batteryHeaterNoPowerBool = "battery_heater_no_power"
		
		case driverTemperatureSetting	= "driver_temp_setting"
		case fanStatus					 = "fan_status"
		
		case insideTemperature			= "inside_temp"
		
		case isAutoConditioningOnBool		 = "is_auto_conditioning_on"
		case isClimateOnBool                  = "is_climate_on"
		case isFrontDefrosterOnBool			 = "is_front_defroster_on"
		case isRearDefrosterOnBool			 = "is_rear_defroster_on"
		
		case isPreconditioningBool		= "is_preconditioning"
		
		case leftTemperatureDirection	 = "left_temp_direction"
		
		case maxAvailableTemperature     = "max_avail_temp"
		case minAvailableTemperature     = "min_avail_temp"
		
		case outsideTemperature			= "outside_temp"
		
		case passengerTemperatureSetting = "passenger_temp_setting"
		
		case rightTemperatureDirection	 = "right_temp_direction"
		
		
        case seatHeaterLeft				 = "seat_heater_left"
		case seatHeaterRearCenter		 = "seat_heater_rear_center"
		case seatHeaterRearLeft			 = "seat_heater_rear_left"
		case seatHeaterRearLeftBack		 = "seat_heater_rear_left_back"
		case seatHeaterRearRight			 = "seat_heater_rear_right"
		case seatHeaterRearRightBack		 = "seat_heater_rear_right_back"
		case seatHeaterRight				 = "seat_heater_right"
		
		case sideMirrorHeaters				= "side_mirror_heaters"
		case steeringWheelHeater			= "steering_wheel_heater"
		case wiperBladeHeater				= "wiper_blade_heater"
		
        case smartPreconditioning		 = "smart_preconditioning"
		
		case timeStamp					= "timestamp"
        
	}
}
