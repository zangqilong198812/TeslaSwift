//
//  ErrorMessage.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 28/02/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

open class ErrorMessage: Mappable {
	
	open var error: String?
	open var description: String?
	
	required public init?(map: Map) { }
	
	open func mapping(map: Map) {
		error		<- map["error"]
		description	<- map["error_description"]
	}
}
