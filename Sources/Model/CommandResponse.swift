//
//  CommandResponse.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/04/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class CommandResponse: Mappable {
	
	public var result:Bool?
	public var reason:String?
	
	required public init?(_ map: Map){ }
	
	public func mapping(map: Map) {
		result	<- map["result"]
		reason	<- map["reason"]
	}
}
