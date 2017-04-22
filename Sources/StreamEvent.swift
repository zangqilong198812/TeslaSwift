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

open class StreamEvent: Mappable {
	
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
    open var odometer: Double?
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
    
    // MARK: Mappable protocol
    
    required public init?(map: Map) { }
    
    open func mapping(map: Map) {
		
		let distanceTransform = TransformOf<Distance, Double>(fromJSON: { Distance(miles: $0!) }, toJSON: {$0?.miles})
		
        timestamp	<- (map["timestamp"], TeslaTimeStampTransform())
        odometer	<- map["odometer"]
        soc         <- map["soc"]
        elevation	<- map["elevation"]
        estLat      <- map["est_lat"]
        estLng		<- map["est_lng"]
        power       <- map["power"]
        shiftState	<- map["shift_state"]
        range       <- (map["range"], distanceTransform)
        estRange	<- (map["est_range"], distanceTransform)
        estHeading	<- map["est_heading"]
        heading     <- map["heading"]
    }
}
