//
//  StreamEvent.swift
//  TeslaSwift
//
//  Created by Jacob Holland on 4/11/17.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation

import CoreLocation

open class StreamEvent {
	
    open var timestamp: TimeInterval?
    open var speed: CLLocationSpeed?
    open var odometer: Distance?
    open var soc: Int?
    open var elevation: Int?
    open var estLat: CLLocationDegrees?
    open var estLng: CLLocationDegrees?
    open var power: Int?
    open var shiftState: String?
    open var range: Distance?
    open var estRange: Distance?
    open var estHeading: CLLocationDirection?
    open var heading: CLLocationDirection?
	
	open var position: CLLocation? {
		if let latitude = estLat,
			let longitude = estLng,
			let heading = heading,
			let timestamp = timestamp {
			let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			return CLLocation(coordinate: coordinate,
			                  altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0,
			                  course: heading,
			                  speed: speed ?? 0,
			                  timestamp: Date(timeIntervalSince1970: timestamp/1000))
			
		}
		return nil
	}
	
	init(values: String) {
		// timeStamp,speed,odometer,soc,elevation,est_heading,est_lat,est_lng,power,shift_state,range,est_range,heading
		
		let separatedValues = values.components(separatedBy: ",")
		
		guard separatedValues.count > 11 else { return }
		
		if let timeValue = Double(separatedValues[0]) {
			timestamp = timeValue
		}
		speed = CLLocationSpeed(separatedValues[1])
		if let value = Double(separatedValues[2]) {
			odometer = Distance(miles: value)
		}
		soc = Int(separatedValues[3])
		elevation = Int(separatedValues[4])
		estHeading = CLLocationDirection(separatedValues[5])
		estLat = CLLocationDegrees(separatedValues[6])
		estLng = CLLocationDegrees(separatedValues[7])
		power = Int(separatedValues[8])
		shiftState = separatedValues[9]
		if let value = Double(separatedValues[10]) {
			range = Distance(miles: value)
		}
		if let value = Double(separatedValues[11]) {
			estRange = Distance(miles: value)
		}
		heading = CLLocationDirection(separatedValues[12])
	}

}

extension StreamEvent: CustomStringConvertible {
	public var description: String {
		return "speed: \(speed ?? -1), odo: \(odometer?.kms ?? -1.0), soc: \(soc ?? -1), elevation: \(elevation ?? -1), power: \(power ?? -1), shift: \(shiftState ?? ""), range: \(range?.kms ?? -1), estRange: \(estRange?.kms ?? -1) heading: \(heading ?? -1), estHeading: \(estHeading ?? -1)"
	}
}
