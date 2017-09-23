//
//  CommandResponse.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/04/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class CommandResponse: Codable {
	
	open var result: Bool?
	open var reason: String?
	
	enum CodingKeys: String, CodingKey {
		case result	 = "response.result"
		case reason	 = "response.reason"
	}
}
