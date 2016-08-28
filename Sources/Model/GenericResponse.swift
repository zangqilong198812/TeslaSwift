//
//  GenericResponse.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 24/06/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class GenericResponse<T:Mappable>: Mappable {
	
	public var response: T!
	
	// MARK: Mappable protocol
	required public init?(_ map: Map) {
		if map["response"].currentValue == nil {
			return nil
		}
	}
	
	public func mapping(map: Map) {
		response	<- map["response"]
	}
	
}

public class GenericArrayResponse<T:Mappable>: Mappable {
	
	public var response: [T]!
	
	// MARK: Mappable protocol
	required public init?(_ map: Map) {
		if map["response"].currentValue == nil {
			return nil
		}
	}
	
	public func mapping(map: Map) {
		response	<- map["response"]
	}
	
}


public class GenericBoolResponse: Mappable {
	
	public var response: Bool!
	
	// MARK: Mappable protocol
	required public init?(_ map: Map) {
		if map["response"].currentValue == nil {
			return nil
		}
	}
	
	public func mapping(map: Map) {
		response	<- map["response"]
	}
	
}
