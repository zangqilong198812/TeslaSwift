//
//  VehicleState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 06/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class VehicleState {

	internal(set) var mobileAccess:Bool?
	internal(set) var chargeState:ChargeState?
}





public class ChargeState:Mappable {
	
	enum ChargingState:String {
		case Complete = "Complete"
		case Charging = "Charging"
	}
	
	struct Distance {
		private var value:Double
		
		init(miles:Double) {
			value = miles
		}
		init(kms:Double) {
			value = kms / 1.609344
		}
		
		var miles:Double { return value }
		var kms:Double { return value * 1.609344 }
	}
	
	/**
	Current state of the charging
	*/
	internal(set) var chargingState:ChargingState?
	/**
	Charge to max rate or standard
	*/
	internal(set) var chargeToMaxRange:Bool?
	internal(set) var maxRangeChargeCounter:Int?
	/**
	Vehicle connected to supercharger?
	*/
	internal(set) var fastChargerPresent:Bool?
	
	/**
	Rated Miles
	*/
	internal(set) var batteryRange:Distance?
	/**
	Range estimated from recent driving
	*/
	internal(set) var estimatedBatteryRange:Distance?
	/**
	Ideal Miles
	*/
	internal(set) var idealBatteryRange:Distance?
	/**
	Percentage of the battery
	*/
	internal(set) var batteryLevel:Int?
	/**
	Current flowing into the battery
	*/
	internal(set) var batteryCurrent:Int?
	
	internal(set) var chargeStartingRange:Double?
	internal(set) var chargeStartingSOC:Double?
	
	/**
	Voltage. Only has value while charging
	*/
	internal(set) var chargerVoltage:Int?
	/**
	Max current allowed by charger and adapter
	*/
	internal(set) var chargerPilotCurrent:Int?
	/**
	Current actually being drawn
	*/
	internal(set) var chargerActualCurrent:Int?
	/**
	KW of charger
	*/
	internal(set) var chargerPower:Int?
	
	
	/**
	Only valid while charging
	*/
	internal(set) var timeToFullCharge:Int?
	/**
	miles/hour while charging or -1 if not charging
	*/
	internal(set) var chargeRate:Int?
	/**
	Vehicle charging por is open?
	*/
	internal(set) var chargePortDoorOpen:Bool?
	
	
	public required init?(_ map: Map) { }
	
	public func mapping(map: Map) {
		chargingState			<- map["charging_state"]
		chargeToMaxRange		<- map["charge_to_max_range"]
		maxRangeChargeCounter	<- map["max_range_charge_counter"]
		fastChargerPresent		<- map["fast_charger_present"]
		batteryRange			<- map["battery_range"]
		estimatedBatteryRange	<- map["est_battery_range"]
		idealBatteryRange		<- map["ideal_battery_range"]
		batteryLevel			<- map["battery_level"]
		batteryCurrent			<- map["battery_current"]
		chargeStartingRange		<- map["charge_starting_range"]
		chargeStartingSOC		<- map["charge_starting_soc"]
		chargerVoltage			<- map["charger_voltage"]
		chargerPilotCurrent		<- map["charger_pilot_current"]
		chargerActualCurrent	<- map["charger_actual_current"]
		chargerPower			<- map["charger_power"]
		timeToFullCharge		<- map["time_to_full_charge"]
		chargeRate				<- map["charge_rate"]
		chargePortDoorOpen		<- map["charge_port_door_open"]
	}
}