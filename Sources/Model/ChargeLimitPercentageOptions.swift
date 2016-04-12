//
//  ChargeRatePercentageOptions.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/04/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class ChargeLimitPercentageOptions: Mappable {
	
	public var percentage:Int {
		didSet {
			if percentage < 0 {
				percentage = 0
			} else if percentage > 100 {
				percentage = 100
			}
		}
	}
	
	init(percentage: Int) {
		self.percentage = percentage
	}
	
	required public init?(_ map: Map){
		percentage = 0
	}
	
	public func mapping(map: Map) {
		percentage <- map["percentage"]
	}
}