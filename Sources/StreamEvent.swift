//
//  StreamEvent.swift
//  TeslaSwift
//
//  Created by Jacob Holland on 4/11/17.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

open class StreamEvent {
	
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
	
    open var timestamp: Date?
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
			let date = timestamp {
			let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			return CLLocation(coordinate: coordinate,
			                  altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0,
			                  course: heading,
			                  speed: speed ?? 0,
			                  timestamp: date)
			
		}
		return nil
	}
	
	init(values: String) {
		// timeStamp,speed,odometer,soc,elevation,est_heading,est_lat,est_lng,power,shift_state,range,est_range,heading
		
		let separatedValues = values.components(separatedBy: ",")
		
		guard separatedValues.count > 11 else { return }
		
		if let timeValue = Int(separatedValues[0]) {
			timestamp = Date(timeIntervalSince1970: TimeInterval(timeValue/1000))
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
