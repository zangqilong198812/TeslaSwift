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
	
	open var batteryHeaterOn: Bool?
	/**
	Percentage of the battery
	*/
	open var batteryLevel: Int?
	/**
	Rated Miles
	*/
	open var ratedBatteryRange: Distance?
	open var chargeCurrentRequest: Int?
	open var chargeCurrentRequestMax: Int?
	open var chargeEnableRequest: Bool?
	open var chargeEnergyAdded: Double?
	
	open var chargeLimitSOC: Int?
	open var chargeLimitSOCMax: Int?
	open var chargeLimitSOCMin: Int?
	open var chargeLimitSOCStandard: Int?
	
	
	open var chargeDistanceAddedIdeal: Distance?
	open var chargeDistanceAddedRated: Distance?
	
	/**
	Vehicle charging port is open?
	*/
	open var chargePortDoorOpen: Bool?
	open var chargePortLatch: String?
	
	/**
	miles/hour while charging or 0 if not charging
	*/
	open var chargeRate: Distance?
	/**
	Charge to max rate or standard
	*/
	open var chargeToMaxRange: Bool?
	
	/**
	Current actually being drawn
	*/
	open var chargerActualCurrent: Int?
	open var chargerPhases: Int?
	/**
	Max current allowed by charger and adapter
	*/
	open var chargerPilotCurrent: Int?
	/**
	KW of charger
	*/
	open var chargerPower: Int?
	/**
	Voltage. Only has value while charging
	*/
	open var chargerVoltage: Int?
	
	/**
	Current state of the charging
	*/
	open var chargingState: ChargingState?
	
	open var connChargeCable: String?
	
	/**
	Range estimated from recent driving
	*/
	open var estimatedBatteryRange: Distance?
	
	open var euVehicle: Bool?
	
	open var fastChargerBrand: String?
	/**
	Vehicle connected to supercharger?
	*/
	open var fastChargerPresent: Bool?
	open var fastChargerType: String?
	
	/**
	Ideal Miles
	*/
	open var idealBatteryRange: Distance?
	open var managedChargingActive: Bool?
	open var managedChargingStartTime: Date?
	open var managedChargingUserCanceled: Bool?
	
	open var maxRangeChargeCounter: Int?
	
	open var notEnoughPowerToHeat: Bool?
	
	open var scheduledChargingPending: Bool?
	open var scheduledChargingStartTime: TimeInterval?
	
	/**
	Only valid while charging
	*/
	open var timeToFullCharge: Double?
	open var timeStamp: Date?
	
	open var tripCharging: Bool?
	
	open var usableBatteryLevel: Int?
	open var userChargeEnableRequest: Bool?
	
	enum CodingKeys: String, CodingKey {
		
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
		
		case chargeDistanceAddedIdeal    = "charge_miles_added_ideal"
		case chargeDistanceAddedRated    = "charge_miles_added_rated"
		
		case chargePortDoorOpen           = "charge_port_door_open"
		case chargePortLatch				 = "charge_port_latch"
		
		case chargeRate                  = "charge_rate"
		case chargeToMaxRange             = "charge_to_max_range"
		
		case chargerActualCurrent         = "charger_actual_current"
		case chargerPhases				 = "charger_phases"
		case chargerPilotCurrent          = "charger_pilot_current"
		case chargerPower                 = "charger_power"
		case chargerVoltage               = "charger_voltage"
		
		case chargingState                = "charging_state"
		
		case connChargeCable				= "conn_charge_cable"
		
		case estimatedBatteryRange      = "est_battery_range"//, distanceTransform)
		
		case euVehicle					 = "eu_vehicle"
		
		case fastChargerBrand			= "fast_charger_brand"
		case fastChargerPresent           = "fast_charger_present"
		case fastChargerType				 = "fast_charger_type"
		
		case idealBatteryRange          = "ideal_battery_range"//, distanceTransform)
		
		case managedChargingActive		 = "managed_charging_active"
		case managedChargingStartTime	 = "managed_charging_start_time"
		case managedChargingUserCanceled	 = "managed_charging_user_canceled"
		
		case maxRangeChargeCounter        = "max_range_charge_counter"
		
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
