//
//  DrivingPosition.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import CoreLocation

open class DriveState: Codable {
	
	open var shiftState: String?
	
	open var speed: CLLocationSpeed?
	open var latitude: CLLocationDegrees?
	open var longitude: CLLocationDegrees?
	open var heading: CLLocationDirection?
	open var date: Date?
	open var timeStamp: Date?
	
	
	open var position: CLLocation? {
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
	
	enum CodingKeys: String, CodingKey {
		case shiftState	 = "shift_state"
		case speed		 = "speed"
		case latitude	 = "latitude"
		case longitude	 = "longitude"
		case heading		 = "heading"
		case date		= "gps_as_of"//, DateTransform())
		case timeStamp	= "timestamp"//, TeslaTimeStampTransform())
	}

	
}
