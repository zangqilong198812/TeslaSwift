//
//  TeslaTimeStampTransform.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/03/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation

/*
class TeslaTimeStampTransform: DateTransform {
	
	open override func transformFromJSON(_ value: Any?) -> Date? {
		if let timeInt = value as? Double {
			return Date(timeIntervalSince1970: TimeInterval(timeInt/1000))
		}
		
		if let timeStr = value as? String {
			return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
		}
		
		return nil
	}
	
	open override func transformToJSON(_ value: Date?) -> Double? {
		if let date = value {
			return Double(date.timeIntervalSince1970 * 1000)
		}
		return nil
	}
}
*/
