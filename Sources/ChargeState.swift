//
//  ChargeState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class ChargeState: Codable {
	
	public enum ChargingState: String, Codable {
		case Complete
		case Charging
		case Disconnected
		case Stopped
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
	
	enum CodingKeys: String, CodingKey {
		
		//let distanceTransform = TransformOf<Distance, Double>(fromJSON: { Distance(miles: $0!) }, toJSON: {$0?.miles})
		
		case batteryCurrent               = "battery_current"
		case batteryHeaterOn				 = "battery_heater_on"
		case batteryLevel                 = "battery_level"
		case ratedBatteryRange           = "battery_range"//, distanceTransform)
		case chargeCurrentRequest		 = "charge_current_request"
		case chargeCurrentRequestMax		 = "charge_current_request_max"
		case chargeEnableRequest			 = "charge_enable_request"
		case chargeEnergyAdded            = "charge_energy_added"
		
		case chargeLimitSOC               = "charge_limit_soc"
		case chargeLimitSOCMax            = "charge_limit_soc_max"
		case chargeLimitSOCMin            = "charge_limit_soc_min"
		case chargeLimitSOCStandard       = "charge_limit_soc_std"
		
		case chargeDistanceAddedIdeal    = "charge_miles_added_ideal"//, distanceTransform)
		case chargeDistanceAddedRated    = "charge_miles_added_rated"//, distanceTransform)
		
		case chargePortDoorOpen           = "charge_port_door_open"
		case chargePortLatch				 = "charge_port_latch"
		
		case chargeRate                  = "charge_rate"//, distanceTransform)
		case chargeToMaxRange             = "charge_to_max_range"
		
		case chargerActualCurrent         = "charger_actual_current"
		case chargerPhases				 = "charger_phases"
		case chargerPilotCurrent          = "charger_pilot_current"
		case chargerPower                 = "charger_power"
		case chargerVoltage               = "charger_voltage"
		
		case chargingState                = "charging_state"
		
		case estimatedBatteryRange      = "est_battery_range"//, distanceTransform)
		
		case euVehicle					 = "eu_vehicle"
		
		case fastChargerPresent           = "fast_charger_present"
		case fastChargerType				 = "fast_charger_type"
		
		case idealBatteryRange          = "ideal_battery_range"//, distanceTransform)
		
		case managedChargingActive		 = "managed_charging_active"
		case managedChargingStartTime	 = "managed_charging_start_time"
		case managedChargingUserCanceled	 = "managed_charging_user_canceled"
		
		case maxRangeChargeCounter        = "max_range_charge_counter"
		
		case motorizedChargePort			 = "motorized_charge_port"
		
		case notEnoughPowerToHeat		 = "not_enough_power_to_heat"
		
		case scheduledChargingPending	 = "scheduled_charging_pending"
		case scheduledChargingStartTime	 = "scheduled_charging_start_time"
		
		case timeToFullCharge             = "time_to_full_charge"
		
		case timeStamp					= "timestamp"//, TeslaTimeStampTransform())
		
		case tripCharging				 = "trip_charging"
		
		case usableBatteryLevel			 = "usable_battery_level"
		
		case userChargeEnableRequest		 = "user_charge_enable_request"
	}
}
