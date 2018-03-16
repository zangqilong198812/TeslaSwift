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
	
	private var batteryHeaterOnBool: Int?
	open var batteryHeaterOn: Bool? { return batteryHeaterOnBool == 1 }
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
	private var chargeEnableRequestBool: Int?
	open var chargeEnableRequest: Bool? { return chargeEnableRequestBool == 1 }
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
	private var chargePortDoorOpenBool: Int?
	open var chargePortDoorOpen: Bool? { return chargePortDoorOpenBool == 1 }
	open var chargePortLatch: String?
	
	/**
	miles/hour while charging or 0 if not charging
	*/
	open var chargeRate: Distance?
	/**
	Charge to max rate or standard
	*/
	private var chargeToMaxRangeBool: Int?
	open var chargeToMaxRange: Bool? { return chargeToMaxRangeBool == 1 }
	
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
	
	private var euVehicleBool: Int?
	open var euVehicle: Bool? { return euVehicleBool == 1 }
	
	open var fastChargerBrand: String?
	/**
	Vehicle connected to supercharger?
	*/
	private var fastChargerPresentBool: Int?
	open var fastChargerPresent: Bool? { return fastChargerPresentBool == 1 }
	open var fastChargerType: String?
	
	/**
	Ideal Miles
	*/
	open var idealBatteryRange: Distance?
	
	private var managedChargingActiveBool: Int?
	open var managedChargingActive: Bool? { return managedChargingActiveBool == 1 }
	open var managedChargingStartTime: Date?
	private var managedChargingUserCanceledBool: Int?
	open var managedChargingUserCanceled: Bool? { return managedChargingUserCanceledBool == 1 }
	
	open var maxRangeChargeCounter: Int?
	
	private var notEnoughPowerToHeatBool: Int?
	open var notEnoughPowerToHeat: Bool? { return notEnoughPowerToHeatBool == 1 }
	
	private var scheduledChargingPendingBool: Int?
	open var scheduledChargingPending: Bool? { return scheduledChargingPendingBool == 1 }
	open var scheduledChargingStartTime: TimeInterval?
	
	/**
	Only valid while charging
	*/
	open var timeToFullCharge: Double?
	open var timeStamp: Date?
	
	private var tripChargingBool: Int?
	open var tripCharging: Bool? { return tripChargingBool == 1 }
	
	open var usableBatteryLevel: Int?
	private var userChargeEnableRequestBool: Int?
	open var userChargeEnableRequest: Bool? { return userChargeEnableRequestBool == 1 }
	
	enum CodingKeys: String, CodingKey {
		
		case batteryHeaterOnBool				 = "battery_heater_on"
		case batteryLevel                 = "battery_level"
		case ratedBatteryRange           = "battery_range"//, distanceTransform)
		case chargeCurrentRequest		 = "charge_current_request"
		case chargeCurrentRequestMax		 = "charge_current_request_max"
		case chargeEnableRequestBool			 = "charge_enable_request"
		case chargeEnergyAdded            = "charge_energy_added"
		
		case chargeLimitSOC               = "charge_limit_soc"
		case chargeLimitSOCMax            = "charge_limit_soc_max"
		case chargeLimitSOCMin            = "charge_limit_soc_min"
		case chargeLimitSOCStandard       = "charge_limit_soc_std"
		
		case chargeDistanceAddedIdeal    = "charge_miles_added_ideal"
		case chargeDistanceAddedRated    = "charge_miles_added_rated"
		
		case chargePortDoorOpenBool           = "charge_port_door_open"
		case chargePortLatch				 = "charge_port_latch"
		
		case chargeRate                  = "charge_rate"
		case chargeToMaxRangeBool             = "charge_to_max_range"
		
		case chargerActualCurrent         = "charger_actual_current"
		case chargerPhases				 = "charger_phases"
		case chargerPilotCurrent          = "charger_pilot_current"
		case chargerPower                 = "charger_power"
		case chargerVoltage               = "charger_voltage"
		
		case chargingState                = "charging_state"
		
		case connChargeCable				= "conn_charge_cable"
		
		case estimatedBatteryRange      = "est_battery_range"//, distanceTransform)
		
		case euVehicleBool					 = "eu_vehicle"
		
		case fastChargerBrand			= "fast_charger_brand"
		case fastChargerPresentBool           = "fast_charger_present"
		case fastChargerType				 = "fast_charger_type"
		
		case idealBatteryRange          = "ideal_battery_range"//, distanceTransform)
		
		case managedChargingActiveBool		 = "managed_charging_active"
		case managedChargingStartTime	 = "managed_charging_start_time"
		case managedChargingUserCanceledBool	 = "managed_charging_user_canceled"
		
		case maxRangeChargeCounter        = "max_range_charge_counter"
		
		case notEnoughPowerToHeatBool		 = "not_enough_power_to_heat"
		
		case scheduledChargingPendingBool	 = "scheduled_charging_pending"
		case scheduledChargingStartTime	 = "scheduled_charging_start_time"
		
		case timeToFullCharge             = "time_to_full_charge"
		
		case timeStamp					= "timestamp"//, TeslaTimeStampTransform())
		
		case tripChargingBool				 = "trip_charging"
		
		case usableBatteryLevel			 = "usable_battery_level"
		
		case userChargeEnableRequestBool		 = "user_charge_enable_request"
	}
}
