//
//  ChargeState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

open class ChargeState: Mappable {
	
	public enum ChargingState: String {
		case Complete
		case Charging
		case Disconnected
		case Stopped
	}
	
	public struct Distance {
		fileprivate var value: Double
		
		public init(miles: Double?) {
			value = miles ?? 0.0
		}
		public init(kms: Double) {
			value = kms / 1.609344
		}
		
		public var miles: Double { return value }
		public var kms: Double { return value * 1.609344 }
	}
	
	/**
	Current flowing into the battery
	*/
	open internal(set) var batteryCurrent: Double?
	open internal(set) var batteryHeaterOn: Bool?
	/**
	Percentage of the battery
	*/
	open internal(set) var batteryLevel: Int?
	/**
	Rated Miles
	*/
	open internal(set) var ratedBatteryRange: Distance?
	open internal(set) var chargeCurrentRequest: Int?
	open internal(set) var chargeCurrentRequestMax: Int?
	open internal(set) var chargeEnableRequest: Bool?
	open internal(set) var chargeEnergyAdded: Double?
	
	open internal(set) var chargeLimitSOC: Int?
	open internal(set) var chargeLimitSOCMax: Int?
	open internal(set) var chargeLimitSOCMin: Int?
	open internal(set) var chargeLimitSOCStandard: Int?
	
	
	open internal(set) var chargeDistanceAddedIdeal: Distance?
	open internal(set) var chargeDistanceAddedRated: Distance?
	
	/**
	Vehicle charging port is open?
	*/
	open internal(set) var chargePortDoorOpen: Bool?
	open internal(set) var chargePortLatch: String?
	
	/**
	miles/hour while charging or 0 if not charging
	*/
	open internal(set) var chargeRate: Distance?
	/**
	Charge to max rate or standard
	*/
	open internal(set) var chargeToMaxRange: Bool?
	
	/**
	Current actually being drawn
	*/
	open internal(set) var chargerActualCurrent: Int?
	open internal(set) var chargerPhases: Int?
	/**
	Max current allowed by charger and adapter
	*/
	open internal(set) var chargerPilotCurrent: Int?
	/**
	KW of charger
	*/
	open internal(set) var chargerPower: Int?
	/**
	Voltage. Only has value while charging
	*/
	open internal(set) var chargerVoltage: Int?
	
	/**
	Current state of the charging
	*/
	open internal(set) var chargingState: ChargingState?
	
	/**
	Range estimated from recent driving
	*/
	open internal(set) var estimatedBatteryRange: Distance?
	
	open internal(set) var euVehicle: Bool?
	
	/**
	Vehicle connected to supercharger?
	*/
	open internal(set) var fastChargerPresent: Bool?
	open internal(set) var fastChargerType: String?
	
	/**
	Ideal Miles
	*/
	open internal(set) var idealBatteryRange: Distance?
	
	open internal(set) var managedChargingActive: Bool?
	open internal(set) var managedChargingStartTime: Date?
	open internal(set) var managedChargingUserCanceled: Bool?
	
	open internal(set) var maxRangeChargeCounter: Int?
	
	open internal(set) var motorizedChargePort: Bool?
	open internal(set) var notEnoughPowerToHeat: Bool?
	
	open internal(set) var scheduledChargingPending: Bool?
	open internal(set) var scheduledChargingStartTime: TimeInterval?
	
	/**
	Only valid while charging
	*/
	open internal(set) var timeToFullCharge: Double?
	open internal(set) var timeStamp: Date?
	
	open internal(set) var tripCharging: Bool?
	
	open internal(set) var usableBatteryLevel: Int?
	open internal(set) var userChargeEnableRequest: Bool?
	
	
	public required init?(map: Map) { }
	
	open func mapping(map: Map) {
		
		let distanceTransform = TransformOf<Distance, Double>(fromJSON: { Distance(miles: $0!) }, toJSON: {$0?.miles})
		
		batteryCurrent              <- map["battery_current"]
		batteryHeaterOn				<- map["battery_heater_on"]
		batteryLevel                <- map["battery_level"]
		ratedBatteryRange           <- (map["battery_range"], distanceTransform)
		chargeCurrentRequest		<- map["charge_current_request"]
		chargeCurrentRequestMax		<- map["charge_current_request_max"]
		chargeEnableRequest			<- map["charge_enable_request"]
		chargeEnergyAdded           <- map["charge_energy_added"]
		
		chargeLimitSOC              <- map["charge_limit_soc"]
		chargeLimitSOCMax           <- map["charge_limit_soc_max"]
		chargeLimitSOCMin           <- map["charge_limit_soc_min"]
		chargeLimitSOCStandard      <- map["charge_limit_soc_std"]
		
		chargeDistanceAddedIdeal    <- (map["charge_miles_added_ideal"], distanceTransform)
		chargeDistanceAddedRated    <- (map["charge_miles_added_rated"], distanceTransform)
		
		chargePortDoorOpen          <- map["charge_port_door_open"]
		chargePortLatch				<- map["charge_port_latch"]
		
		chargeRate                  <- (map["charge_rate"], distanceTransform)
		chargeToMaxRange            <- map["charge_to_max_range"]
		
		chargerActualCurrent        <- map["charger_actual_current"]
		chargerPhases				<- map["charger_phases"]
		chargerPilotCurrent         <- map["charger_pilot_current"]
		chargerPower                <- map["charger_power"]
		chargerVoltage              <- map["charger_voltage"]
		
		chargingState               <- map["charging_state"]
		
		estimatedBatteryRange       <- (map["est_battery_range"], distanceTransform)
		
		euVehicle					<- map["eu_vehicle"]
		
		fastChargerPresent          <- map["fast_charger_present"]
		fastChargerType				<- map["fast_charger_type"]
		
		idealBatteryRange           <- (map["ideal_battery_range"], distanceTransform)
		
		managedChargingActive		<- map["managed_charging_active"]
		managedChargingStartTime	<- map["managed_charging_start_time"]
		managedChargingUserCanceled	<- map["managed_charging_user_canceled"]
		
		maxRangeChargeCounter       <- map["max_range_charge_counter"]
		
		motorizedChargePort			<- map["motorized_charge_port"]
		
		notEnoughPowerToHeat		<- map["not_enough_power_to_heat"]
		
		scheduledChargingPending	<- map["scheduled_charging_pending"]
		scheduledChargingStartTime	<- map["scheduled_charging_start_time"]
		
		timeToFullCharge            <- map["time_to_full_charge"]
		
		timeStamp					<- (map["timestamp"], TeslaTimeStampTransform())
		
		tripCharging				<- map["trip_charging"]
		
		usableBatteryLevel			<- map["usable_battery_level"]
		
		userChargeEnableRequest		<- map["user_charge_enable_request"]
	}
}
