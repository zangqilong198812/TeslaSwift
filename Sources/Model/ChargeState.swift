//
//  ChargeState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class ChargeState: Mappable {
	
	public enum ChargingState: String {
		case Complete = "Complete"
		case Charging = "Charging"
		case Disconnected = "Disconnected"
	}
	
	public struct Distance {
		private var value: Double
		
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
	Current state of the charging
	*/
	public internal(set) var chargingState: ChargingState?
	/**
	Charge to max rate or standard
	*/
	public internal(set) var chargeToMaxRange: Bool?
	public internal(set) var maxRangeChargeCounter: Int?
	/**
	Vehicle connected to supercharger?
	*/
	public internal(set) var fastChargerPresent: Bool?
	
	/**
	Rated Miles
	*/
	public internal(set) var batteryRange: Distance?
	/**
	Range estimated from recent driving
	*/
	public internal(set) var estimatedBatteryRange: Distance?
	/**
	Ideal Miles
	*/
	public internal(set) var idealBatteryRange: Distance?
	/**
	Percentage of the battery
	*/
	public internal(set) var batteryLevel: Int?
	/**
	Current flowing into the battery
	*/
	public internal(set) var batteryCurrent: Double?
	
	public internal(set) var chargeStartingRange: Double?
	public internal(set) var chargeStartingSOC: Double?
	
	/**
	Voltage. Only has value while charging
	*/
	public internal(set) var chargerVoltage: Int?
	/**
	Max current allowed by charger and adapter
	*/
	public internal(set) var chargerPilotCurrent: Int?
	/**
	Current actually being drawn
	*/
	public internal(set) var chargerActualCurrent: Int?
	/**
	KW of charger
	*/
	public internal(set) var chargerPower: Int?
	
	
	/**
	Only valid while charging
	*/
	public internal(set) var timeToFullCharge: Int?
	/**
	miles/hour while charging or -1 if not charging
	*/
	public internal(set) var chargeRate: Double?
	/**
	Vehicle charging por is open?
	*/
	public internal(set) var chargePortDoorOpen: Bool?
	
	
	public required init?(_ map: Map) { }
	
	public func mapping(map: Map) {
		
		let distanceTransform = TransformOf<Distance, Double>(fromJSON: { Distance(miles: $0!) }, toJSON: {$0?.miles})
		
		chargingState			<- map["charging_state"]
		chargeToMaxRange		<- map["charge_to_max_range"]
		maxRangeChargeCounter	<- map["max_range_charge_counter"]
		fastChargerPresent		<- map["fast_charger_present"]
		batteryRange			<- (map["battery_range"], distanceTransform)
		estimatedBatteryRange	<- (map["est_battery_range"], distanceTransform)
		idealBatteryRange		<- (map["ideal_battery_range"], distanceTransform)
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
