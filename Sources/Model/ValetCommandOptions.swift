//
//  ValetCommandOptions.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/04/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class ValetCommandOptions: Mappable {
	
	public var on:Bool = false
	public var password:String?
	
	init(valetActivated: Bool, pin: String?) {
		on = valetActivated
		password = pin
	}
	
	required public init?(_ map: Map){ }
	
	public func mapping(map: Map) {
		on			<- map["on"]
		password	<- map["password"]
	}
}