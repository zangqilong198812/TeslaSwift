//
//  GuiSettings.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 17/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class GuiSettings: Codable {
	
	open var distanceUnits: String?
	open var temperatureUnits: String?
	open var chargeRateUnits: String?
	open var time24HoursBool: Int?
	open var time24Hours: Bool? { return time24HoursBool == 1 }
	open var rangeDisplay: String?
	open var timeStamp: TimeInterval?
	
	
	enum CodingKeys: String, CodingKey {
		case distanceUnits		 = "gui_distance_units"
		case temperatureUnits	 = "gui_temperature_units"
		case chargeRateUnits		 = "gui_charge_rate_units"
		case time24HoursBool			 = "gui_24_hour_time"
		case rangeDisplay		 = "gui_range_display"
		case timeStamp			= "timestamp"//, TeslaTimeStampTransform())
	}
}
