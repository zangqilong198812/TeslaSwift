//
//  DrivingPosition.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

public class DriveState: Mappable {
	
	public var shiftState: String?
	
	public var speed: CLLocationSpeed?
	public var latitude: CLLocationDegrees?
	public var longitude: CLLocationDegrees?
	public var heading: CLLocationDirection?
	public var date: NSDate?
	
	public var position: CLLocation? {
		if let latitude = latitude,
			let longitude = longitude,
			let heading = heading,
			let date = date {
				let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
				return CLLocation(coordinate: coordinate,
					altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0,
					course: heading,
					speed: speed ?? 0,
					timestamp: date)
				
		}
		return nil
	}
	
	required public init?(_ map: Map) {
		
	}
	
	public func mapping(map: Map) {
		shiftState	<- map["shift_state"]
		speed		<- map["speed"]
		latitude	<- map["latitude"]
		longitude	<- map["longitude"]
		heading		<- map["heading"]
		date		<- (map["gps_as_of"], DateTransform())
	}

	
}
